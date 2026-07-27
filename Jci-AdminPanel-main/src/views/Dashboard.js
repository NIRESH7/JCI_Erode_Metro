import React, { useState, useEffect } from "react";
import axios from 'axios'
import { ToastContainer, toast } from 'react-toastify';
import ChartistGraph from "react-chartist";

// react-bootstrap components
import {
  Badge,
  Button,
  Card,
  Navbar,
  Nav,
  Table,
  Container,
  Row,
  Col,
  Form,
  OverlayTrigger,
  Tooltip,
} from "react-bootstrap";


function Dashboard() {

  const [userList, setUserList] = useState([]);
  const [eventlist, setEventlist] = useState([]);
  const [sponser, setSponser] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [data, setData] = useState(null);

  useEffect(() => {
    axios.get(process.env.REACT_APP_URL_ADMIN+"/member/allmembers").then((res) => {
      setUserList(res.data.response.data.info);
    });
    axios.post(process.env.REACT_APP_URL_ADMIN+"/member/our_sponser", { role: "sponser", id: "" }).then((res) => {
      setSponser(res.data.response.data.info);
    });
    axios.get(process.env.REACT_APP_URL_ADMIN+"/member/allevents").then((res) => {
      setEventlist(res.data.response.data.info);
    });
  }, []);


  const handleSubmit = (e) => {
    e.preventDefault();
    setLoading(true);
    setIsError(false);
    setChannel("")
    const data = {
      channel:channel,
    };
  
    axios
      .post(process.env.REACT_APP_URL_ADMIN+"/jciadmin/createMember", data)
      .then((res) => {
        setChannel("")
        toast.success("Member created successfully!")
        setLoading(false);
      })
      .catch((err) => {
        if(err.response && err.response.data &&err.response.data.error&&typeof err.response.data.error.message==="string")
        if(err.response.data.error.message==="Authentication Failed"){
        localStorage.clear();
        window.location.reload();
        }
        setLoading(false);
        setIsError(true);
        toast.error("Failed to create channel!")
      });
  };


  return (
    <>
      <ToastContainer/>
      <Container fluid>
        <Row>
          <Col lg="4" sm="6">
            <Card className="card-stats" style={{ backgroundColor: "white" }}>
              <Card.Body >
                <Row >
                  <Col xs="5" >
                    <div className="icon-big text-center icon-warning d-flex ml-3">
                      <i class='bx bxs-user text-warning'></i>
                    </div>
                  </Col>
                  <Col xs="7" >
                    <div className="numbers" >
                      <p className="card-category" style={{fontWeight:"normal",fontSize:"20px",color:"black"}}> Member</p>
                      <Card.Title as="h4" style={{fontWeight:"normal",fontSize:"20px",color:"black"}}> {userList.length}</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="4" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning d-flex ml-3" >
                      <i class='bx bx-calendar-event text-success'></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category" style={{fontWeight:"normal",fontSize:"20px",color:"black"}}>Events</p>
                      <Card.Title as="h4" style={{fontWeight:"normal",fontSize:"20px",color:"black"}}>{eventlist.length}</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">


                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="4" sm="12">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning d-flex ml-3">
                      <i class='bx bx-money text-warning' ></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category" style={{fontWeight:"normal",fontSize:"20px",color:"black"}}>Sponser</p>
                      <Card.Title as="h4" style={{fontWeight:"normal",fontSize:"20px",color:"black"}}>{sponser.length}</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">


                </div>
              </Card.Footer>
            </Card>
          </Col>

        </Row>
        






        {/* <Row>
          <Col md="8">
            <Card>
              <Card.Header>
                <Card.Title as="h4">Users Behavior</Card.Title>
                <p className="card-category">24 Hours performance</p>
              </Card.Header>
              <Card.Body>
                <div className="ct-chart" id="chartHours">
                  <ChartistGraph
                    data={{
                      labels: [
                        "9:00AM",
                        "12:00AM",
                        "3:00PM",
                        "6:00PM",
                        "9:00PM",
                        "12:00PM",
                        "3:00AM",
                        "6:00AM",
                      ],
                      series: [
                        [287, 385, 490, 492, 554, 586, 698, 695],
                        [67, 152, 143, 240, 287, 335, 435, 437],
                        [23, 113, 67, 108, 190, 239, 307, 308],
                      ],
                    }}
                    type="Line"
                    options={{
                      low: 0,
                      high: 800,
                      showArea: false,
                      height: "245px",
                      axisX: {
                        showGrid: false,
                      },
                      lineSmooth: true,
                      showLine: true,
                      showPoint: true,
                      fullWidth: true,
                      chartPadding: {
                        right: 50,
                      },
                    }}
                    responsiveOptions={[
                      [
                        "screen and (max-width: 640px)",
                        {
                          axisX: {
                            labelInterpolationFnc: function (value) {
                              return value[0];
                            },
                          },
                        },
                      ],
                    ]}
                  />
                </div>
              </Card.Body>
              <Card.Footer>
                <div className="legend">
                  <i className="fas fa-circle text-info"></i>
                  Open <i className="fas fa-circle text-danger"></i>
                  Click <i className="fas fa-circle text-warning"></i>
                  Click Second Time
                </div>
                <hr></hr>
                <div className="stats">
                  <i className="fas fa-history"></i>
                  Updated 3 minutes ago
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col md="4">
            <Card>
              <Card.Header>
                <Card.Title as="h4">Email Statistics</Card.Title>
                <p className="card-category">Last Campaign Performance</p>
              </Card.Header>
              <Card.Body>
                <div
                  className="ct-chart ct-perfect-fourth"
                  id="chartPreferences"
                >
                  <ChartistGraph
                    data={{
                      labels: ["40%", "20%", "40%"],
                      series: [40, 20, 40],
                    }}
                    type="Pie"
                  />
                </div>
                <div className="legend">
                  <i className="fas fa-circle text-info"></i>
                  Open <i className="fas fa-circle text-danger"></i>
                  Bounce <i className="fas fa-circle text-warning"></i>
                  Unsubscribe
                </div>
                <hr></hr>
                <div className="stats">
                  <i className="far fa-clock"></i>
                  Campaign sent 2 days ago
                </div>
              </Card.Body>
            </Card>
          </Col>
        </Row> */}
      </Container>
    </>
  );
}

export default Dashboard;
