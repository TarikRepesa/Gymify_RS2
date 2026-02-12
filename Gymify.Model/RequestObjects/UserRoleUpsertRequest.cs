using System;

namespace Gymify.Model.RequestObjects
{
    public class UserRoleUpsertRequest
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }
        public DateTime DateAssigned { get; set; }
    }
}
