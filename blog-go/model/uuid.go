package model

import "github.com/rs/xid"

func getId() string {
	var guid = xid.New()
	return guid.String()
}
