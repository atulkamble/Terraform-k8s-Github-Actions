import {
    Button,
    Paper,
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow,
    TextField
} from "@mui/material";
import axios from "axios";
import { useEffect, useState } from "react";

const SERVER_URL = process.env.REACT_APP_SERVER_URL;

function App() {
    const [employees, setEmployees] = useState([]);
    const [employeeDetails, setEmployeeDetails] = useState({ name: '', employeeId: 0 });

    // GET request to fetch employees
    async function fetchEmployees() {
        try {
            const response = await axios.get(`${SERVER_URL}/employees`);
            setEmployees(response.data);
        } catch (error) {
            console.error("Error fetching employees:", error);
        }
    }

    // POST request to create employee
    async function createEmployee() {
        try {
            await axios.post(`${SERVER_URL}/employees`, {
                name: employeeDetails.name,
                employee_id: parseInt(employeeDetails.employeeId)
            });
            await fetchEmployees(); // Refresh the list
            setEmployeeDetails({ ...employeeDetails, name: '', employeeId: 0 });
        } catch (error) {
            console.error(`Error adding employee: ${JSON.stringify(error)}`);
        }
    }

    const handleSetName = (e) => {
        setEmployeeDetails({ ...employeeDetails, name: e.target.value });
    };

    const handleSetEmployeeId = (e) => {
        setEmployeeDetails({ ...employeeDetails, employeeId: e.target.value });
    };

    useEffect(() => {
        fetchEmployees();
    }, []);

    return (
        <>
            <div className="App" style={{
                paddingTop: "50px",
                display: "flex",
                justifyContent: "space-between",
                padding: "1rem calc(100vh - 50rem)",
            }}>
                <TextField id="standard-basic" label="Name" variant="standard" onChange={handleSetName} />
                <TextField
                    id="standard-number"
                    label="Id"
                    type="number"
                    InputLabelProps={{ shrink: true }}
                    variant="standard"
                    onChange={handleSetEmployeeId}
                />
                <Button variant="contained" onClick={createEmployee}>Add Employees</Button>
            </div>
            <TableContainer component={Paper} style={{
                display: "flex",
                alignItems: "center",
                paddingTop: "2rem",
                justifyContent: "center",
            }}>
                <Table sx={{ maxWidth: 600 }} aria-label="simple table">
                    <TableHead>
                        <TableRow>
                            <TableCell align="right">Employee Name</TableCell>
                            <TableCell align="right">Employee Id</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {employees.map((employee, index) => (
                            <TableRow key={index} sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
                                <TableCell component="th" scope="row">{employee.name}</TableCell>
                                <TableCell align="right">{employee.employee_id}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>
        </>
    );
}

export default App;
