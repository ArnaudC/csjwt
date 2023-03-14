namespace ApiWithAuth;

// Information a user must send in order to login.
public class AuthRequest
{
    public string Email { get; set; } = null!;
    public string Password { get; set; } = null!;
}
