package services

import (
	p "boom-service/internal/proto"
	"errors"
	"github.com/gofiber/contrib/websocket"
	"google.golang.org/protobuf/proto"
	"log"
	"sync"
	"time"
)

type WebSocketService struct {
}

func NewWebSocketService() *WebSocketService {
	// 检查心跳
	go func() {
		defer func() {
			if r := recover(); r != nil {
				log.Println(r)
			}
		}()
		heartbeat()
	}()

	// 注册注销
	go func() {
		defer func() {
			if r := recover(); r != nil {
				log.Println(r)
			}
		}()
		register()
	}()
	return &WebSocketService{}
}

type client struct {
	ID            string          // 连接ID
	Socket        *websocket.Conn // 连接
	HeartbeatTime int64           // 前一次心跳时间
	Service       *WebSocketService
}

// 消息类型
const (
	heartbeatCheckTime = 121 // 心跳检测几秒检测一次
	heartbeatTime      = 360 // 心跳距离上一次的最大时间

	chanBufferRegister   = 100 // 注册chan缓冲
	chanBufferUnregister = 100 // 注销chan大小
)

// ClientManager 客户端管理
type ClientManager struct {
	Clients map[string]*client // 保存连接
	mu      *sync.RWMutex
}

// Manager 定义一个管理Manager
var Manager = ClientManager{
	Clients: make(map[string]*client), // 参与连接的用户，出于性能的考虑，需要设置最大连接数
	mu:      new(sync.RWMutex),
}

var (
	registerChan   = make(chan *client, chanBufferRegister)   // 注册
	unregisterChan = make(chan *client, chanBufferUnregister) // 注销
)

// 注册注销
func register() {
	for {
		select {
		case conn := <-registerChan: // 新注册，新连接
			// 加入连接,进行管理
			add(conn)

		case conn := <-unregisterChan: // 注销，或者没有心跳

			// 删除Client
			remove(conn)
		}
	}
}

// 绑定账号
func add(c *client) {
	Manager.mu.Lock()
	defer Manager.mu.Unlock()

	if cc, ok := Manager.Clients[c.ID]; ok {
		_ = cc.Socket.Close()
		delete(Manager.Clients, cc.ID)
	}

	Manager.Clients[c.ID] = c

}

// 解绑账号
func remove(c *client) {
	_ = c.Socket.Close()
	Manager.mu.Lock()
	defer Manager.mu.Unlock()
	_ = c.Socket.Close()
	delete(Manager.Clients, c.ID)
}

// 维持心跳
func heartbeat() {
	for {
		// 获取所有的Clients
		Manager.mu.RLock()
		clients := make([]*client, len(Manager.Clients))
		for _, c := range Manager.Clients {
			clients = append(clients, c)
		}
		Manager.mu.RUnlock()

		for _, c := range clients {
			if time.Now().Unix()-c.HeartbeatTime > heartbeatTime {
				remove(c)
			}
		}

		time.Sleep(time.Second * heartbeatCheckTime)
	}
}

// Send 发送消息
func (s WebSocketService) Send(id string, data []byte) error {
	// 获取用户连接
	Manager.mu.RLock()
	client, ok := Manager.Clients[id]
	Manager.mu.RUnlock()

	if !ok {
		return errors.New("用户未连接")
	}

	// 发送消息
	err := client.Socket.WriteMessage(websocket.BinaryMessage, data)
	if err != nil {
		return err
	}
	return nil
}

func (s *WebSocketService) NewClient(conn *websocket.Conn, ID string) {
	// 创建一个实例连接
	client := &client{
		ID:            ID,
		HeartbeatTime: time.Now().Unix(),
		Socket:        conn,
		Service:       s,
	}

	// 用户注册到用户连接管理
	registerChan <- client

	defer func() {
		err := client.Socket.Close()
		if err != nil {
			println("关闭连接失败" + err.Error())
		}
	}()
	for {
		_, body, err := client.Socket.ReadMessage()
		if err != nil {
			break
		}
		client.ReadHandler(body)
	}
}

func (c *client) ReadHandler(message []byte) {
	var body p.Body
	err := proto.Unmarshal(message, &body)
	if err != nil {
		log.Println(err)
		return
	}
	switch body.Type {
	case p.Type_offer:
		c.Service.Send(body.To, message)
	case p.Type_answer:
		c.Service.Send(body.To, message)
	case p.Type_candidate:
		c.Service.Send(body.To, message)
	case p.Type_assist:
		c.Service.Send(body.To, message)
	case p.Type_bye:
		c.Service.Send(body.To, message)
	case p.Type_keepalive:
		c.HeartbeatTime = time.Now().Unix()

	default:
		log.Println("未知消息类型")
	}
}
