package controller

import (
	"blog-go/conf"
	"context"
	"io"
	"math/rand"
	"mime/multipart"
	"os"
	"path"
	"time"
	"unsafe"

	"github.com/labstack/echo/v4"
	"github.com/qiniu/go-sdk/v7/auth/qbox"
	"github.com/qiniu/go-sdk/v7/storage"
)

const (
	digit     = "0123456789"
	lowercase = "abcdefghijklmnopqrstuvwxyz"
	chars     = digit + lowercase
	charsLen  = len(chars)
	digitLen  = len(digit)
	charsMask = 1<<6 - 1
	digitMask = 1<<4 - 1
)

var rng = rand.NewSource(time.Now().UnixNano())

func UploadFile(ctx echo.Context) error {
	file, err := ctx.FormFile("file")
	if err != nil {
		return ctx.JSON(Fail("未发现文件", err.Error()))
	}
	var imgUrl string
	switch conf.Conf.Img.Type {
	case "local":
		{
			imgUrl, err = uploadToLocal(file)
			if err != nil {
				return ctx.JSON(Fail("文件保存失败", err.Error()))
			}
			break
		}
	case "qiniu":
		{
			src, err := file.Open()
			if err != nil {
				return ctx.JSON(Fail("文件保存失败", err.Error()))
			}
			defer src.Close()
			imgUrl, err = uploadToQiniu(src, file.Size)
			if err != nil {
				return ctx.JSON(Fail("文件保存失败", err.Error()))
			}
			break
		}
	default:
		{
			return ctx.JSON(Fail("未配置"))
		}
	}

	return ctx.JSON(Succ("上传成功", imgUrl))
}

func uploadToQiniu(file multipart.File, fileSize int64) (string, error) {
	putPolicy := storage.PutPolicy{
		Scope: conf.Conf.Img.Bucket,
	}
	mac := qbox.NewMac(conf.Conf.Img.AccessKey, conf.Conf.Img.SecretKey)
	upToken := putPolicy.UploadToken(mac)
	cfg := storage.Config{
		// 空间对应的机房
		Zone: &storage.ZoneXinjiapo,
		// 是否使用https域名
		UseHTTPS: true,
		// 上传是否使用CDN上传加速
		UseCdnDomains: false}
	// 构建表单上传的对象
	formUploader := storage.NewFormUploader(&cfg)
	ret := storage.PutRet{}
	// 可选配置
	putExtra := storage.PutExtra{}
	err := formUploader.PutWithoutKey(context.Background(), &ret, upToken, file, fileSize, &putExtra)
	return ret.Key, err
}

func uploadToLocal(file *multipart.FileHeader) (string, error) {
	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()
	dir := time.Now().Format("200601/02")
	os.MkdirAll("./static/upload/"+dir[:6], 0755)
	name := "static/upload/" + dir + RandStr(10) + path.Ext(file.Filename)
	dst, err := os.Create(name)
	if err != nil {
		return "", err
	}
	defer dst.Close()
	_, err = io.Copy(dst, src)
	return name, err
}

func RandStr(ln int) string {
	/* chars 36个字符
	 * rng.Int63() 每次产出64bit的随机数,每次我们使用6bit(2^6=64) 可以使用10次
	 */
	buf := make([]byte, ln)
	for idx, cache, remain := 0, rng.Int63(), 10; idx < ln; {
		if remain == 0 {
			cache, remain = rng.Int63(), 10
		}
		buf[idx] = chars[int(cache&charsMask)%charsLen]
		cache >>= 6
		remain--
		idx++
	}
	return *(*string)(unsafe.Pointer(&buf))
}
