package model

import (
	"errors"
	"time"

	"github.com/jinzhu/copier"
	"gorm.io/gorm"
)

type Tag struct {
	CreatedAt time.Time      `json:"-"`
	UpdatedAt time.Time      `json:"-"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	ID        string         `json:"objectId" gorm:"primaryKey" validate:"required"`
	Name      string         `json:"name" validate:"required,max=10"`
	Articles  []*Article     `json:"articles,omitempty" gorm:"many2many:article_tags"`
}

type TagItem struct {
	ID   string `json:"objectId"`
	Name string `json:"name"`
}

func AddTag(name string) (*Tag, error) {
	db := getDB()
	mod := &Tag{}
	if db.Where("name=?", name).Find(mod); mod.ID == "" {
		mod = &Tag{Name: name, ID: getId()}
		err := db.Create(mod).Error
		return mod, err
	}
	err := errors.New("已存在")
	return nil, err
}

func EditTag(mod *Tag) error {
	db := getDB()
	err := db.First(&Tag{}, "id = ?", mod.ID).Updates(mod).Error
	return err
}

func GetTags() (*[]*TagItem, error) {
	db := getDB()
	originMods := &[]*Tag{}
	err := db.Order("created_at desc").Find(originMods).Error
	if err != nil {
		return &[]*TagItem{}, err
	}
	mods := &[]*TagItem{}
	err = copier.Copy(mods, originMods)
	return mods, err
}

func GetTagInfo(ID string) (*Tag, error) {
	db := getDB()
	mod := &Tag{ID: ID}
	err := db.Preload("Articles").First(mod).Error
	return mod, err
}

func DeleteTag(ID string) error {
	db := getDB()
	return db.Delete(&Tag{}, "id=?", ID).Error
}
