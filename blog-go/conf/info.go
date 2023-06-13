package conf

import "os"

var info Info

type Info struct {
	RunEnv   string `json:"runEnv"`
	ConfFile bool   `json:"confFile"`
}

func InitInfo() {
	if os.Getenv("VERCEL") == "1" {
		info.RunEnv = "vercel"
		info.ConfFile = false
	} else {
		info.RunEnv = "local"
		info.ConfFile = true
	}
}

func GetInfo() Info {
	return info
}
