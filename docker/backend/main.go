package main

import (
	"employees/controller"
	"employees/repository"
	"employees/routes"
	"employees/service"
	"fmt"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
	"os"
	"time"
)

func main() {
	app := fiber.New()

	// Enable CORS
	app.Use(cors.New())
	app.Use(cors.New(cors.Config{
		AllowOrigins: os.Getenv("ALLOWED_ORIGINS"),
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	// Initialize DB with retry
	db := initializeDatabaseConnectionWithRetry(5)

	// DB setup
	repository.RunMigrations(db)
	employeeRepository := repository.NewEmployeeRepository(db)
	employeeService := service.NewEmployeeService(employeeRepository)
	employeeController := controller.NewEmployeeController(employeeService)

	// Register routes
	routes.RegisterRoute(app, employeeController)

	// Start server
	err := app.Listen(":8080")
	if err != nil {
		log.Fatalln(fmt.Sprintf("error starting the server: %s", err.Error()))
	}
}

func initializeDatabaseConnectionWithRetry(maxRetries int) *gorm.DB {
	var db *gorm.DB
	var err error

	dsn := createDsn()

	for i := 1; i <= maxRetries; i++ {
		db, err = gorm.Open(postgres.New(postgres.Config{
			DSN:                  dsn,
			PreferSimpleProtocol: true,
		}), &gorm.Config{})

		if err == nil {
			log.Println("✅ Connected to database.")
			return db
		}

		log.Printf("❌ DB connection failed (%d/%d): %v", i, maxRetries, err)
		time.Sleep(3 * time.Second)
	}

	log.Fatalln(fmt.Sprintf("💥 Failed to connect to DB after %d retries: %v", maxRetries, err))
	return nil
}

func createDsn() string {
	dsnFormat := "host=%s user=%s password=%s dbname=%s port=%s sslmode=disable"
	dbHost := os.Getenv("DB_HOST")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")
	dbPort := os.Getenv("DB_PORT")
	return fmt.Sprintf(dsnFormat, dbHost, dbUser, dbPassword, dbName, dbPort)
}
