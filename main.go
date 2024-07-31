package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	cmd "main/command"
	db "main/database"
)

func main() {
	if len(os.Args) <= 1 {
		log.Fatal("Wrong input. Run rtm --help")
	}

	local_db := db.Check_database()

	args := os.Args[1:]
	command := args[0]

	switch command {

	//Status
	case "status":
		var temp_task []db.Task

		status := local_db.Find(&temp_task)

		if status.Error != nil {
			log.Fatal(status.Error)
		} else {
			fmt.Println("ID \t Status \t Description")
			for _, item := range temp_task {
				if item.Status == "DONE" {
					fmt.Println(item.ID, "\t\033[32m", item.Status, "\033[0m\t\t", item.Name)
				} else {
					fmt.Println(item.ID, "\t\033[34m", item.Status, "\033[0m\t\t", item.Name)
				}
			}
		}

	//ADD
	case "add":
		task_description := strings.Join(os.Args[2:], " ")
		task := db.Task{Name: task_description, Status: "TODO"}
		result := local_db.Create(&task)
		if result.Error != nil {
			log.Fatal(result.Error)
		} else {
			fmt.Println("Task:", task.Name, "added")
			fmt.Println(result.RowsAffected)
		}

	//Delete
	case "del", "rm":
		task_id := os.Args[2]
		//Delete based on ID
		delresult := local_db.Delete(&db.Task{}, task_id)
		if delresult.Error != nil {
			log.Fatal(delresult.Error)
		} else {
			fmt.Println("Task ID", task_id, "Deleted")
		}

	//Done
	case "done":
		task_id := os.Args[2]

		result := local_db.Model(&db.Task{}).Where("ID = ?", task_id).Update("Status", "DONE")
		if result.Error != nil {
			log.Fatal(result.Error)
		} else {
			fmt.Println("Task", task_id, "is now Done! Good Job.")
		}

	//Help
	case "--help", "help", "-h":
		cmd.Help()
	default:
		fmt.Println("Please provide a proper input.")
		fmt.Println("Type rtm --help for help")
	}
}
