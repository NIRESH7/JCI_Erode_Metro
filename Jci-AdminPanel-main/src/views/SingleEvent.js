import React, { useState, useEffect } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";
import { BrowserRouter as Router, Link, useLocation } from "react-router-dom";
function SingleEvent(props) {
    function useQuery() {
        return new URLSearchParams(useLocation().search);
    }
    let query = useQuery();
    const [event, setEvent] = useState(null);

    useEffect(() => {
        const id = query.get("id");
        axios.post(process.env.REACT_APP_URL_ADMIN+"/member/event", { id }).then((res) => {
            setEvent(res.data.response.data.info);
        });
    }, []);
    return (
        <>

            <div className="container-fluid p-3">
                <div className="card mb-3" style={{ maxWidth: "400px" }}>
                    <div className="row g-0">
                        <div className="col-md-4">
                            <img src={event?.event_image} className="img-fluid rounded-start" alt={event?.event_name} />
                        </div>
                        <div className="col-md-8">
                            <div className="card-body">
                                <p className="card-title">
                                    <span style={{ fontWeight: "bold" }}>Event Name: </span>
                                    {event?.event_name}</p>
                                <p className="card-text">
                                    <span style={{ fontWeight: "bold" }}>Event Date: </span>
                                    {event?.event_date}</p>
                                <p className="card-text">
                                    <span style={{ fontWeight: "bold" }}>Event Time: </span>
                                    {event?.event_time}</p>
                                <p className="card-text">
                                    <span style={{ fontWeight: "bold" }}>Event Location: </span>
                                    {event?.event_location}</p>

                            </div>
                        </div>
                        <div className="col-md-8" style={{margin:"65px"}}>
                            <div className="card-body">
                                <p style={{ fontWeight: "bold",textAlign:"center"}}>Event Description</p>
                                <p  style={{ textAlign:"center"}}className="card-text ">{event?.event_desc}</p>

                            </div>
                        </div>
                    </div>
                </div>
                {setEvent.length == 0 && (
                    <tr>
                        <td className="text-center" colSpan="4">
                            <b>No data found to display.</b>
                        </td>
                    </tr>
                )}

            </div>

        </>
    );
}
export default SingleEvent;