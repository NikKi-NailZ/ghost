{{if .Copyright}}
    {{.Copyright}}
{{end}}
package repository

import (
	"database/sql"
	"time"
)

// Block for query statements.
const (
	AllFields = "*"
	Count     = "count(*)"
)

// ToNullString - helper for creating null string from string
func ToNullString(value string) sql.NullString {
	return sql.NullString{
		String: value,
		Valid:  value != "",
	}
}

// ToNullInt64 - helper for creating null string from string
func ToNullInt64(value int64) sql.NullInt64 {
	return sql.NullInt64{
		Int64: value,
		Valid: value != 0,
	}
}

// ToNullTime - helper for creating null time from time
func ToNullTime(value time.Time) sql.NullTime {
	return sql.NullTime{
		Time:  value,
		Valid: !value.IsZero(),
	}
}
