package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"

	cmd "main/command"
	db "main/database"

	"gorm.io/gorm"
)

func main() {
	if len(os.Args) <= 1 {
		cmd.Help()
		return
	}

	local_db := db.Check_database()
	args := os.Args[1:]
	command := args[0]

	switch command {
	case "ls":
		var tasks []db.Task
		result := local_db.Order("id ASC").Find(&tasks)
		if result.Error != nil {
			log.Fatal(result.Error)
		}

		fmt.Println("ID\tSTATUS\tTASK")
		for _, task := range tasks {
			fmt.Printf("%d\t%s\t%s\n", task.ID, colorStatus(task.Status), task.Name)
		}

	case "add":
		if len(args) < 2 {
			log.Fatal("Usage: rtm add TASK NAME")
		}

		taskName := strings.TrimSpace(strings.Join(args[1:], " "))
		if taskName == "" {
			log.Fatal("Task name cannot be empty")
		}

		task := db.Task{Name: taskName, Status: "TODO"}
		result := local_db.Create(&task)
		if result.Error != nil {
			log.Fatal(result.Error)
		}
		fmt.Printf("Task %d added\n", task.ID)

	case "edit":
		if len(args) < 2 {
			log.Fatal("Usage: rtm edit ID")
		}

		var task db.Task
		result := local_db.First(&task, args[1])
		if result.Error != nil {
			log.Fatal(result.Error)
		}

		fmt.Printf("New task name [%s]: ", task.Name)
		reader := bufio.NewReader(os.Stdin)
		newName, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}

		newName = strings.TrimSpace(newName)
		if newName == "" {
			fmt.Println("Task unchanged")
			return
		}

		result = local_db.Model(&task).Update("Name", newName)
		if result.Error != nil {
			log.Fatal(result.Error)
		}
		fmt.Printf("Task %d updated\n", task.ID)

	case "del":
		if len(args) < 2 {
			log.Fatal("Usage: rtm del ID")
		}
		deleteTask(local_db, args[1])

	case "done":
		if len(args) < 2 {
			log.Fatal("Usage: rtm done ID")
		}
		updateTaskStatus(local_db, args[1], "DONE")

	case "undo":
		if len(args) < 2 {
			log.Fatal("Usage: rtm undo ID")
		}
		updateTaskStatus(local_db, args[1], "TODO")

	case "inp":
		if len(args) < 2 {
			log.Fatal("Usage: rtm inp ID")
		}
		updateTaskStatus(local_db, args[1], "INP")

	case "stop":
		if len(args) < 2 {
			log.Fatal("Usage: rtm stop ID")
		}
		updateTaskStatus(local_db, args[1], "STOP")

	case "--help", "help", "-h":
		cmd.Help()

	default:
		fmt.Println("Unknown command.")
		cmd.Help()
	}
}

func updateTaskStatus(local_db *gorm.DB, taskID string, status string) {
	result := local_db.Model(&db.Task{}).Where("ID = ?", taskID).Update("Status", status)
	if result.Error != nil {
		log.Fatal(result.Error)
	}
	if result.RowsAffected == 0 {
		log.Fatal("Task not found")
	}
	fmt.Printf("Task %s -> %s\n", taskID, status)
}

func deleteTask(local_db *gorm.DB, taskID string) {
	result := local_db.Delete(&db.Task{}, taskID)
	if result.Error != nil {
		log.Fatal(result.Error)
	}
	if result.RowsAffected == 0 {
		log.Fatal("Task not found")
	}
	fmt.Printf("Task %s deleted\n", taskID)
}

func colorStatus(status string) string {
	switch status {
	case "TODO":
		return "\033[34mTODO\033[0m"
	case "INP":
		return "\033[33mINP\033[0m"
	case "DONE":
		return "\033[32mDONE\033[0m"
	case "STOP":
		return "\033[31mSTOP\033[0m"
	default:
		return status
	}
}
