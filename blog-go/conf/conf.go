package conf

import (
	"fmt"
	"log"
	"strings"

	"github.com/fsnotify/fsnotify"
	"github.com/spf13/viper"
)

var Conf Cfg

type Cfg struct {
	DB      DB      `yaml:"db" json:"db"`
	Manager Manager `yaml:"manager" json:"manager"`
	Img     Img     `yaml:"img" json:"img"`
}

type DB struct {
	DBType   string `yaml:"dbType" json:"dbType"`
	Host     string `yaml:"host" json:"host"`
	User     string `yaml:"user" json:"user"`
	Password string `yaml:"password" json:"password"`
	Dbname   string `yaml:"dbname" json:"dbname"`
	Port     int    `yaml:"port" json:"port"`
}

type Manager struct {
	Name     string `yaml:"name" json:"name"`
	Password string `yaml:"password" json:"password"`
}

type Img struct {
	Type      string `yaml:"type" json:"type"`
	AccessKey string `yaml:"accessKey" json:"accessKey"`
	SecretKey string `yaml:"secretKey" json:"secretKey"`
	Bucket    string `yaml:"bucket" json:"bucket"`
}

func init() {
	InitInfo()
	viper.AddConfigPath("./")
	viper.SetConfigName("conf")
	viper.SetConfigType("yaml")
	viper.SetDefault("manager.name", "admin")
	viper.SetDefault("manager.password", "123456")
	viper.SetDefault("db.dbType", "sqlite")
	viper.SetDefault("db.host", "")
	viper.SetDefault("db.user", "")
	viper.SetDefault("db.password", "")
	viper.SetDefault("db.dbname", "")
	viper.SetDefault("db.port", 0)
	viper.SetDefault("img.type", "local")
	viper.AutomaticEnv()
	replacer := strings.NewReplacer(".", "_")
	viper.SetEnvKeyReplacer(replacer)
	if info.ConfFile {
		err := viper.SafeWriteConfig()
		if err != nil {
			fmt.Println(err.Error())
		}
		if err := viper.ReadInConfig(); err != nil {
			fmt.Println("read config file failed, ", err.Error())
			info.ConfFile = false
		}
	}
	if err := viper.Unmarshal(&Conf); err != nil {
		log.Printf("unmarshal config file failed, %v", err.Error())
	}
	if info.ConfFile {
		// 监控配置文件变化
		viper.WatchConfig()
		// 注意！！！配置文件发生变化后要同步到全局变量Conf
		viper.OnConfigChange(func(in fsnotify.Event) {
			fmt.Println("配置文件被修改")
			if err := viper.Unmarshal(&Conf); err != nil {
				panic(fmt.Errorf("unmarshal conf failed, err:%s ", err))
			}
		})
	}
}

func SaveConfig() bool {
	viper.Set("db", Conf.DB)
	viper.Set("manager", Conf.Manager)
	if info.ConfFile {
		err := viper.WriteConfig()
		if err != nil {
			fmt.Println("write config file failed, ", err.Error())
			if err := viper.Unmarshal(&Conf); err != nil {
				panic(fmt.Errorf("unmarshal conf failed, err:%s ", err))
			}
			return false
		}
	}
	return true
}
