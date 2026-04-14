package token

import (
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"github.com/tndgoat/gopherbank/util"
)

func TestPasetoMaker(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	username := util.RandomOwner()
	duration := time.Minute

	token, err := maker.CreateToken(username, duration)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	payload, err := maker.VerifyToken(token)
	require.NoError(t, err)
	require.NotNil(t, payload)

	require.Equal(t, username, payload.Username)
	require.NotZero(t, payload.ID)
}

func TestExpiredPasetoToken(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	token, err := maker.CreateToken(util.RandomOwner(), -time.Minute)
	require.NoError(t, err)

	payload, err := maker.VerifyToken(token)

	require.Error(t, err)
	require.ErrorIs(t, err, ErrExpiredToken)
	require.Nil(t, payload)
}

func TestInvalidPasetoToken(t *testing.T) {
	maker1, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	token, err := maker1.CreateToken(util.RandomOwner(), time.Minute)
	require.NoError(t, err)

	maker2, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	payload, err := maker2.VerifyToken(token)

	require.Error(t, err)
	require.ErrorIs(t, err, ErrInvalidToken)
	require.Nil(t, payload)
}
