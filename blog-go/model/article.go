package model

import (
	"time"

	"github.com/jinzhu/copier"
	"gorm.io/gorm"
)

type Article struct {
	CreatedAt   time.Time      `json:"-"`
	UpdatedAt   time.Time      `json:"-"`
	DeletedAt   gorm.DeletedAt `json:"-" gorm:"index"`
	ID          string         `json:"objectId" gorm:"primaryKey"`
	Title       string         `json:"title" gorm:"not null"`
	PicUrl      string         `json:"picUrl"`
	Description string         `json:"description"`
	Content     string         `json:"content" gorm:"not null"`
	Tags        []*Tag         `json:"tags,omitempty" gorm:"many2many:article_tags"`
	Comments    []*Comment     `json:"comments" gorm:"foreignKey:ToArticleId"`
	IsPublish   bool           `json:"isPublish" gorm:"default:false;not null"`
}

type ArticleEdit struct {
	ID          string `json:"objectId" gorm:"primaryKey"`
	Title       string `json:"title" validate:"required"`
	PicUrl      string `json:"picUrl"`
	Description string `json:"description"`
	Content     string `json:"content" validate:"required"`
	Tags        []Tag  `json:"tags,omitempty"`
}

type ArticleListItem struct {
	CreatedAt   time.Time `json:"createdAt"`
	ID          string    `json:"objectId" gorm:"primaryKey"`
	Title       string    `json:"title"`
	PicUrl      string    `json:"picUrl"`
	Description string    `json:"description"`
	IsPublish   bool      `json:"isPublish" gorm:"default:false"`
	Tags        []Tag     `json:"tags,omitempty"`
}

type ArticleContent struct {
	CreatedAt time.Time  `json:"createdAt"`
	UpdatedAt time.Time  `json:"updatedAt"`
	Title     string     `json:"title"`
	PicUrl    string     `json:"picUrl"`
	Content   string     `json:"content"`
	Tags      []Tag      `json:"tags,omitempty"`
	Comments  []*Comment `json:"comments" gorm:"foreignKey:CommentId"`
}

var ArticleCount int

func InitNum() {
	db := getDB()
	var count int64
	db.Model(Article{}).Where("is_publish=true").Count(&count)
	ArticleCount = int(count)
}

func GetArticleEdit(ID string) (*ArticleEdit, error) {
	db := getDB()
	originMods := &Article{}
	err := db.Preload("Tags").First(originMods, "id=?", ID).Error
	if err != nil {
		return nil, err
	}
	mods := &ArticleEdit{}
	err = copier.Copy(mods, originMods)
	return mods, err
}

func GetArticleList(page int) (*[]*ArticleListItem, error) {
	db := getDB()
	originMods := &[]*Article{}
	err := db.Preload("Tags").Order("created_at desc").Where("is_publish=true").Limit(10).Offset((page - 1) * 10).Find(originMods).Error
	if err != nil {
		return &[]*ArticleListItem{}, err
	}
	mods := &[]*ArticleListItem{}
	err = copier.Copy(mods, originMods)
	return mods, err
}

func GetArticleListAll() (*[]*ArticleListItem, error) {
	db := getDB()
	originMods := &[]*Article{}
	err := db.Preload("Tags").Order("created_at desc").Preload("Tags").Find(originMods).Error
	if err != nil {
		return &[]*ArticleListItem{}, err
	}
	mods := &[]*ArticleListItem{}
	err = copier.Copy(mods, originMods)
	return mods, err
}

func GetArticleContent(ID string) (*ArticleContent, error) {
	db := getDB()
	originMods := &Article{}
	err := db.Where("id=?", ID).Where("is_publish=true").Preload("Tags").Preload("Comments").Preload("Comments.Replies").First(originMods, "id=?", ID).Error
	if err != nil {
		return nil, err
	}
	mods := &ArticleContent{}
	err = copier.Copy(mods, originMods)
	return mods, err
}

func AddArticle(originMod *ArticleEdit) error {
	db := getDB()
	originMod.ID = getId()
	mod := &Article{}
	err := copier.Copy(mod, originMod)
	if err != nil {
		return err
	}
	err = db.Create(mod).Error
	if err != nil {
		return err
	}
	if mod.Tags != nil {
		err = db.Model(mod).Association("Tags").Replace(mod.Tags)
	}

	return err
}

func EditArticle(originMod *ArticleEdit) error {
	db := getDB()
	mod := &Article{}
	err := copier.Copy(mod, originMod)
	if err != nil {
		return err
	}
	err = db.First(&Article{}, "id = ?", mod.ID).Updates(mod).Error
	if err != nil {
		return err
	}

	err = db.Model(mod).Association("Tags").Replace(mod.Tags)

	return err
}

func DeleteArticle(ID string) error {
	db := getDB()
	return db.Delete(&Article{}, "id=?", ID).Error
}

func ChangePublish(ID string, isPublish bool) error {
	db := getDB()
	return db.First(&Article{}, "id=?", ID).Update("is_publish", isPublish).Error
}
