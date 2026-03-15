using System.Security.Cryptography;

namespace Gymify.Services.Helpers
{
    public static class SecureRandomHelper
    {
        public static string GenerateString(string allowedChars, int length)
        {
            if (string.IsNullOrWhiteSpace(allowedChars))
                throw new ArgumentException("allowedChars ne smije biti prazan.");

            if (length <= 0)
                throw new ArgumentException("length mora biti veći od 0.");

            var result = new char[length];

            for (int i = 0; i < length; i++)
            {
                var index = RandomNumberGenerator.GetInt32(allowedChars.Length);
                result[i] = allowedChars[index];
            }

            return new string(result);
        }
    }
}