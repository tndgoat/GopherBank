package token

import (
	"errors"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

// Different types of error returned by the VerifyToken function
var (
	ErrExpiredToken = errors.New("token has expired")
	ErrInvalidToken = errors.New("token is invalid")
)

// AuthPayload represents user identity
type AuthPayload struct {
	ID       uuid.UUID `json:"id"`
	Username string    `json:"username"`
}

// JWTClaims represents JWT encoded payload
type JWTClaims struct {
	AuthPayload
	jwt.RegisteredClaims
}

// PasetoPayload represents PASETO encrypted payload
type PasetoPayload struct {
	AuthPayload
	IssuedAt  time.Time `json:"issued_at"`
	ExpiredAt time.Time `json:"expired_at"`
}

// NewAuthPayload creates a new identity payload
func NewAuthPayload(username string) (*AuthPayload, error) {
	id, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}

	return &AuthPayload{
		ID:       id,
		Username: username,
	}, nil
}
