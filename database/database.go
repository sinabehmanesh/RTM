package database

import (
	"errors"
	"fmt"
	"log"
	"os"
	"os/user"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

type Task struct {
	ID     uint `gorm:"primaryKey"`
	Name   string
	Status string
}

// Functions for local databases(sql)
func Check_database() *gorm.DB {
	user, err := user.Current()
	if err != nil {
		log.Fatal(err)
	}

	configdir := user.HomeDir + "/.RTM"
	dbfile := configdir + "/gorm.db"

	if _, err := os.Stat(configdir); errors.Is(err, os.ErrNotExist) {
		os.Mkdir(configdir, os.ModePerm)
	}

	if _, err := os.Stat(dbfile); errors.Is(err, os.ErrNotExist) {
		fmt.Println("Database check faild. \n Database does not exist! \n Creating a new one....")
		db := create_database(dbfile)

		db.AutoMigrate(&Task{})

		fmt.Println("Migration successful ✅")
		return db
	} else {
		db := create_database(dbfile)
		return db
	}
}

func create_database(dbfile string) *gorm.DB {
	db, err := gorm.Open(sqlite.Open(dbfile), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}
	return db
}

//Functions for cloud based connection(sql)
//Soon
