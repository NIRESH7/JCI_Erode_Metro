import React from 'react'
import AdminLayout from "layouts/Admin.js";
import EventListEdit from "views/EventListEdit";
import SingleMember from "views/SingleMember";
import SingleEvent from "views/SingleEvent";
import Event_image_single from "views/Event_image_single";
import { BrowserRouter, Route, Switch, Redirect } from "react-router-dom";
import  Login from "./components/Login"
const token=localStorage.getItem("tok");
import AuthVerify from "views/AuthVerify";
import axios from "axios"

if (token) 
axios.defaults.headers.common['adminauthtoken'] = token;

const App = () => {
   

 const logOut = () => {
    localStorage.clear();
    window.location.reload();
}


    return (
        <>
           <Switch>
      {token ?<>
      <Route path="/admin" render={(props) => {("props",props) ; return <AdminLayout {...props} />} } />
      <Redirect from="/" to="/admin/dashboard" />
      <Route path="/admin/EventListEdit/">
        <EventListEdit />
      </Route>
      <Route path="/SingleMember?id=id"><SingleMember /></Route>
      <Route path="/SingleEvent?id=id"><SingleEvent /></Route>
      <Route path="/Event_image_single?id=id"><Event_image_single /></Route></>:<>
      <Route path="/Login"><Login /></Route>
      <Redirect from="*" to="/login"/>
      </>}
    </Switch> 
    <AuthVerify logOut={logOut}/>
        </>
    )
}

export default App
