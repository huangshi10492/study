package services

import (
	"errors"
	"github.com/pion/turn/v3"
	"net"
	"strconv"
)

type TurnConfig struct {
	PublicIP  string
	Port      int
	Realm     string
	StartPort uint16
	EndPort   uint16
}
type TurnService struct {
	udpListener *net.PacketConn
	turnServer  *turn.Server
	Config      TurnConfig
}

func NewTurnService(config TurnConfig) (*TurnService, error) {
	service := &TurnService{
		Config: config,
	}
	if len(config.PublicIP) == 0 {
		println("PublicIP is empty")
		return nil, errors.New("PublicIP is empty")
	}
	udpListener, err := net.ListenPacket("udp", "0.0.0.0:"+strconv.Itoa(config.Port))
	if err != nil {
		println(err.Error())
		return nil, err
	}
	service.udpListener = &udpListener
	turnServer, err := turn.NewServer(turn.ServerConfig{
		Realm: config.Realm,
		AuthHandler: func(username, realm string, srcAddr net.Addr) (key []byte, ok bool) {
			return turn.GenerateAuthKey(username, realm, username), true
		},
		PacketConnConfigs: []turn.PacketConnConfig{
			{
				PacketConn: udpListener,
				RelayAddressGenerator: &turn.RelayAddressGeneratorPortRange{
					RelayAddress: net.ParseIP(config.PublicIP),
					Address:      "0.0.0.0",
					MinPort:      config.StartPort,
					MaxPort:      config.EndPort,
				},
			},
		},
	})
	if err != nil {
		println(err.Error())
		return nil, err
	}
	service.turnServer = turnServer
	return service, nil
}
func (s *TurnService) Close() error {
	return s.turnServer.Close()
}
