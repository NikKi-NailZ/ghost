{{if .Copyright}}
    {{.Copyright}}
{{end}}
package repository

const (
	errNotFound = "not_found"
	errExecute  = "execute_error"
	errAccess   = "access"
)

// ErrNotFound custom error.
// nolint:errname // Error.
type ErrNotFound struct {
	What string
}

// Error interface implementation.
func (e ErrNotFound) Error() string {
	if e.What == "" {
		return errNotFound
	}

	return errNotFound + ": " + e.What
}

// ErrExecute custom error for handling database exec errors.
// nolint:errname // Error.
type ErrExecute struct {
	Cause string
}

// Error implementation.
func (e ErrExecute) Error() string {
	if e.Cause == "" {
		return errExecute
	}

	return errExecute + ": " + e.Cause
}

// ErrAccess custom error for handling database access errors.
// nolint:errname // Error.
type ErrAccess struct {
	Cause string
}

// Error implementation.
func (e ErrAccess) Error() string {
	if e.Cause == "" {
		return errAccess
	}

	return errAccess + ": " + e.Cause
}