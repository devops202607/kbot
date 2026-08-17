package cmd

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	TgToken = os.Getenv("TELE_TOKEN")
)

var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "Starting bot",
	Long:    "Starting bot long description",
	Run: func(cmd *cobra.Command, args []string) {
		log.Printf("[INFO] kbot %s starting", appVersion)

		if TgToken == "" {
			log.Fatal("[FATAL] TELE_TOKEN environment variable is not set")
		}
		log.Printf("[INFO] TELE_TOKEN loaded, length=%d", len(TgToken))

		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TgToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("[FATAL] Bot init error: %s", err)
		}
		log.Println("[INFO] Bot initialized successfully")

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			sender := m.Sender()
			log.Printf("[INFO] Message received from user=%d username=%q text=%q",
				sender.ID, sender.Username, m.Text())

			payload := m.Message().Payload

			switch payload {
			case "hello":
				reply := fmt.Sprintf("Hello, I`m KBot %s!", appVersion)
				log.Printf("[INFO] Sending reply to user=%d: %q", sender.ID, reply)
				err = m.Send(reply)
				if err != nil {
					log.Printf("[ERROR] Failed to send reply to user=%d: %s", sender.ID, err)
				}
			default:
				log.Printf("[WARN] Unknown command %q from user=%d", payload, sender.ID)
			}
			return err
		})

		http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
			log.Printf("[DEBUG] Health check from %s", r.RemoteAddr)
			w.WriteHeader(http.StatusOK)
			fmt.Fprint(w, "ok")
		})

		log.Println("[INFO] Health server listening on :8080")
		go func() {
			if err := http.ListenAndServe(":8080", nil); err != nil {
				log.Fatalf("[FATAL] Health server error: %s", err)
			}
		}()

		log.Println("[INFO] Bot polling started")
		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)
}
