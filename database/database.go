package database

import (
	"errors"
	"fmt"
	"log"
	"os"

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
	if _, err := os.Stat("gorm.db"); errors.Is(err, os.ErrNotExist) {
		fmt.Println("Database check faild. \n Database does not exist! \n Creating a new one....")
		db := create_database()

		fmt.Println("Database created \nStarted Migrating....")
		db.AutoMigrate(&Task{})
		fmt.Println("Migration successful ✅")
		return db
	} else {
		db := create_database()
		return db
	}
}

func create_database() *gorm.DB {
	db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}
	return db
}

//Functions for cloud based connection(sql)
//Soon
