package controller

// 返回格式模型
type Reply struct {
	Code  int         `json:"code"`
	Msg   string      `json:"msg"`
	Count int         `json:"count,omitempty"`
	Data  interface{} `json:"data,omitempty"`
}

const (
	codeSucc     int = 200 //正常
	codeFail     int = 300 //失败
	codeErrInput int = 310 //输入数据有误
	codeErrOut   int = 320 //无数据返回
	codeErrAuth  int = 330 //没有权限
	codeErrToken int = 340 //token错误
	codeErrServe int = 350 //服务端错误
	codeOther    int = 400 //其他约定,eg 更新token
)

func reply(code int, msg string, data ...interface{}) (int, Reply) {
	if len(data) > 0 {
		return 200, Reply{
			Code: code,
			Msg:  msg,
			Data: data[0],
		}
	}
	return 200, Reply{
		Code: code,
		Msg:  msg,
	}
}

//带有数量的响应
func CountSucc(msg string, data interface{}, count int) (int, Reply) {
	return 200, Reply{
		Code:  codeSucc,
		Msg:   msg,
		Count: count,
		Data:  data,
	}
}

//成功响应
func Succ(msg string, data ...interface{}) (int, Reply) {
	return reply(codeSucc, msg, data...)
}

//失败响应
func Fail(msg string, data ...interface{}) (int, Reply) {
	return reply(codeFail, msg, data...)
}

//输入数据错误响应
func ErrInput(msg string, data ...interface{}) (int, Reply) {
	return reply(codeErrInput, msg, data...)
}

//无数据响应
func ErrOut(msg string, data ...interface{}) (int, Reply) {
	return reply(codeErrOut, msg, data...)
}

//权限不足响应
func ErrAuth(msg string, data ...interface{}) (int, Reply) {
	return reply(codeErrAuth, msg, data...)
}

//Token错误响应
func ErrToken(msg string, data ...interface{}) (int, Reply) {
	return reply(codeErrToken, msg, data...)
}

//服务器错误响应
func ErrServer(msg string, data ...interface{}) (int, Reply) {
	return reply(codeErrServe, msg, data...)
}

//其他响应
func Other(msg string, data ...interface{}) (int, Reply) {
	return reply(codeOther, msg, data...)
}
