package main

import (
	"log"
	"math/rand"
	"sync"
	"time"
	"sync/atomic"
)

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.

func do(seconds int, action ...any) {
    log.Println(action...)
    randomMillis := 500 * seconds + rand.Intn(500 * seconds)
    time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

type Order struct {
	id uint64
	customer string
	// make a replay which ic a channel that can take the order (HINT you need a pointer to the order)
	// Also the name of the cook
}
var nextId atomic.Uint64

var Waiter = make(chan *Order, 3)

func Cook(name string) {
	// log that the cook is starting
	// loop forever
	// wait for an order from the waiter
	// cook it
	// put the name of the cook in the order
	// send it back into the reply channel: order.replay <- order
}

func Customer(name string, wg *sync.WaitGroup) {
	for mealsEaten := 0; mealsEaten < 5; {
		// place an order
		// select statement so that if the waiter gets it with 7 seconds 
			// then you get it from the cook, and eat it 
			// if you don't get leave the restaurant
			// do(5, name, "is waiting too long, abandoning the order", order.id)
	} 

}

func main() {
	customers := [10]string{
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}
	var wg sync
	for _, customer := range customers {
		wg.Add(1)
		go Customer(customer, &wg)
	}
	go Cook("Remy")
	go Cook("Linguini")
	go Cook("Colette")
	log.Println("Restaurant closing")
}
