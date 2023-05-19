import { useEffect, useState } from "react";

const Users = () => {
  const [users, setUsers] = useState([]);

  const fetchUsers = async () => {
    const response = await fetch("http://localhost/exercise-3/user/users");
    const data = await response.json();
    setUsers(data.users);
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  if (users.length > 0) {
    return (
      <ul>
        {users.map((user: { name: string }, index: number) => (
          <li key={index}>{user.name}</li>
        ))}
      </ul>
    );
  } else {
    return <h1>Unable to query user service</h1>;
  }
};

export default Users;
