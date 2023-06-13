package model

import (
	"time"

	"gorm.io/gorm"
)

type Comment struct {
	CreatedAt   time.Time      `json:"createdAt"`
	UpdatedAt   time.Time      `json:"-"`
	DeletedAt   gorm.DeletedAt `json:"-" gorm:"index"`
	ID          string         `json:"objetcId" gorm:"primaryKey"`
	Content     string         `json:"content" validate:"required"`
	Owner       string         `json:"owner"`
	Replies     []Reply        `json:"replies,omitempty" gorm:"foreignKey:ToCommentId"`
	ToArticleId string         `json:"toArticleId" validate:"required"`
}

type Reply struct {
	CreatedAt   time.Time      `json:"createdAt"`
	UpdatedAt   time.Time      `json:"-"`
	DeletedAt   gorm.DeletedAt `json:"-" gorm:"index"`
	ID          string         `json:"objectId" gorm:"primaryKey"`
	Content     string         `json:"content" validate:"required"`
	Owner       string         `json:"owner"`
	Replyer     string         `json:"replyer"`
	ToCommentId string         `json:"toCommentId" validate:"required"`
}

func AddComment(mod *Comment) error {
	db := getDB()
	mod.ID = getId()
	err := db.Create(mod).Error
	if err != nil {
		return err
	}
	articleMod := &Article{ID: mod.ToArticleId}
	err = db.Model(articleMod).Association("Comments").Append(mod)
	return err
}

func ReplyComment(mod *Reply) error {
	db := getDB()
	err := db.Create(mod).Error
	if err != nil {
		return err
	}
	commentMod := &Comment{ID: mod.ToCommentId}
	err = db.Model(commentMod).Association("Replies").Append(mod)
	return err
}

func DeleteComment(ID string) error {
	db := getDB()
	err := db.Delete(&Comment{}, "id=?", ID).Error
	return err
}

func DeleteReply(ID string) error {
	db := getDB()
	err := db.Delete(&Reply{}, "id=?", ID).Error
	return err
}
