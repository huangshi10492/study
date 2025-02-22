package config

import (
	"boom-service/internal/services"
	"fmt"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

type Config struct {
	Web  Web
	Turn services.TurnConfig
}

type Web struct {
	Port int
}

type SugaredConfig struct {
	*Config
}

func NewConfig(filePath string) *SugaredConfig {
	// 初始化配置文件
	pflag.StringP("config", "c", filePath, "config file")
	pflag.Parse()
	viper.SetConfigType("yaml")
	err := viper.BindPFlags(pflag.CommandLine)
	if err != nil {
		panic(err)
	}
	conf := viper.GetString("config")
	viper.SetConfigFile(conf)
	if err := viper.ReadInConfig(); err != nil {
		panic(fmt.Sprintf("load config %s fail: %v", conf, err))
	}

	// 解析初始配置
	baseConf := &Config{}
	if err := viper.Unmarshal(baseConf); err != nil {
		if err != nil {
			panic(err)
		}
	}

	// 构造 SugaredConfig
	sugaredConfig := &SugaredConfig{
		Config: baseConf,
	}

	return sugaredConfig
}
