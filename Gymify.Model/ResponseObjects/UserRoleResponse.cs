using System;

namespace Gymify.Model.ResponseObjects
{
    public class UserRoleResponse
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int RoleId { get; set; }
        public DateTime DateAssigned { get; set; }
    }
}
