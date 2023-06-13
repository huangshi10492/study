package common

import (
	"time"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"
)

var UserJwtKey = []byte("huangshi")

var AdminJwtKey = []byte("huangshi10492")

type UserClaims struct {
	ID   string `json:"objectId"`
	Name string `json:"name"`
	jwt.StandardClaims
}

type AdminClaims struct {
	Name string `json:"name"`
	jwt.StandardClaims
}

func ReleaseUserToken(ID string, name string) (string, error) {
	claims := &UserClaims{
		ID:   ID,
		Name: name,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(3 * 24 * time.Hour).Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(UserJwtKey)

	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func GetUserTokenInfo(ctx echo.Context) (string, string) {
	auth := ctx.Get("user").(*jwt.Token)
	claims := auth.Claims.(*UserClaims)
	return claims.ID, claims.Name
}

func ReleaseAdminToken(name string) (string, error) {
	claims := &AdminClaims{
		Name: name,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(3 * 24 * time.Hour).Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(AdminJwtKey)

	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func GetAdminTokenInfo(ctx echo.Context) string {
	auth := ctx.Get("admin").(*jwt.Token)
	claims := auth.Claims.(*AdminClaims)
	return claims.Name
}
