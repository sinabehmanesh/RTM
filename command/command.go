package command

import "fmt"

func Help() {
	fmt.Println("------")
	fmt.Println("rtm [command]")
	fmt.Println()
	fmt.Println("  ls             List tasks")
	fmt.Println("  add TASK       Add a task")
	fmt.Println("  edit ID        Edit a task name")
	fmt.Println("  del ID         Delete a task")
	fmt.Println("  done ID        Set task status to DONE")
	fmt.Println("  undo ID        Set task status to TODO")
	fmt.Println("  inp ID         Set task status to INP")
	fmt.Println("  stop ID        Set task status to STOP")
	fmt.Println("  export         Export tasks to a file")
}
