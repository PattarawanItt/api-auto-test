# 🤖 Robot Framework API Testing – Reqres.in

This project demonstrates automated API testing using Robot Framework and RequestsLibrary, targeting the free public API at https://reqres.in and https://petstore.swagger.io

---

## 📌 Project Goals

- Practice API testing with Robot Framework
- Test basic API Pet flows: Post - Create New Pet / Get - Pet By Stored ID / Put - Pet By Stored ID / Delete - Pet And Verify Deletion
- Test basic reqres.in api flows: GET Schema

---

## 🧪 Tested Endpoints

| Method | Endpoint           | Description               |
|--------|--------------------|---------------------------|
| GET    | /pet/{id}          | Find pet by ID            |
| POST   | /pet               | Add a new pet to the store|
| PUT    | /pet               | Update an existing pet    |
| Delete | /pet/{id}          | Delete a pet              |

| Method | Endpoint           | Description                   |
|--------|--------------------|-------------------------------|
| GET   | /api/users/{id}        | Schema (POSITIVE/NEGATIVE) |

---

