import dotenv from "dotenv";
dotenv.config();

const env = (primary, ...fallbacks) => {
    for (const key of [primary, ...fallbacks]) {
        const value = process.env[key];
        if (value != null && String(value).trim() !== "") return value;
    }
    return undefined;
};

export const secrets = {
    passwordSecret: env("passwordSecret", "PASSWORD_SECRET"),
    jwtAdmin: env("jwtadminSecret", "jwtAdminSecret", "HS_JWT_Admin"),
    jwtSuperAdmin: env("jwtSuperAdminSecret", "jwtSuperAdminSecret", "jwtadminSecret", "HS_JWT_Admin"),
    jwtMember: env("jwtMemberSecret", "jwtMemberSecret", "HS_JWT_Member", "jwtadminSecret", "HS_JWT_Admin"),
    jwtWorkshop: env("jwtWorkshopSecret", "jwtWorkshopSecret"),
    jwtEmail: env("jwtEmailSecret", "jwtEmailSecret", "HS_VERIFYEMAIL"),
};

export const mode = process.env.HS_NODE_ENV || "development";
export const development = {
    database: {
        db_name: process.env.HS_DB_NAME,
        host: process.env.HS_DB_HOST,
        username: process.env.HS_DB_USERNAME,
        password: process.env.HS_DB_PASSWORD,
    },
    server: {
        port: process.env.HS_PORT,
    },

};
export const jwt_admintoken = {
    JWT_Adminkey: secrets.jwtAdmin,
    JWT_SuperAdminkey: secrets.jwtSuperAdmin,
};

export const jwt_membertoken = {
    JWT_Memberkey: secrets.jwtMember,
    JWT_MemberExpiry: process.env.HS_JWT_MEMBER_EXPIRY || "7d",
};

export const jwt_workshop = {
    JWT_Workshopkey: secrets.jwtWorkshop,
};

export const jwt_email = {
    JWT_Emailkey: secrets.jwtEmail,
};

export const password_secret = {
    key: secrets.passwordSecret,
};

export const smtp_config = {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_APP_PASSWORD,
    from: process.env.SMTP_FROM || process.env.SMTP_USER,
};

export const google_config = {
    clientId: process.env.GOOGLE_CLIENT_ID,
    webClientId: process.env.GOOGLE_WEB_CLIENT_ID,
};

export const defaultuser = {

    admin: {
        email_id: "nutzindia@gmail.com",
        phone: "+919944448090",
        username: "Nutzindia",
        password: "nutzadmin",
        user_type: "ROOT",
        status: "active"
    },
    banner: {
        banner_image: "https://ik.imagekit.io/bfzb9z4tav/mesh/patterns_Gzr8HAPWV.jpg?updatedAt=1616250524607",
        status: "active"
    },
    Designation: {
        member_id: "1",
        designation_name: "developer",
        designation_year: "2021",
    },
    events1: {
        event_name: "nutz1",
        event_image: "https://ik.imagekit.io/bfzb9z4tav/portfolio/Birdscale_BvS13W3oScoR.jpg?updatedAt=1625462149213",
        event_date: "22.07.2021",
        event_time: "12.00am",
        event_location: "erode1",
        event_desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    },
    events2: {
        event_name: "nutz2",
        event_image: "https://ik.imagekit.io/bfzb9z4tav/portfolio/Birdscale_BvS13W3oScoR.jpg?updatedAt=1625462149213",
        event_date: "22.07.2021",
        event_time: "12.00am",
        event_location: "erode2",
        event_desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    },
    eventsimage1: {
        event_id: "1",
        event_image: "https://ik.imagekit.io/bfzb9z4tav/Jci/Schermafbeelding-2020-11-15-om-12.50.59_uBkQOkNaT.png?updatedAt=1627301427568",
        status: "active"
    },
    eventsimage2: {
        event_id: "2",
        event_image: "https://ik.imagekit.io/bfzb9z4tav/Jci/d1c7hc4-12b535f0-43a9-48be-9570-73fa79143d7f_KzmBo8Vx9.jpg?updatedAt=1627301427837",
        status: "active"
    },
    Family: {
        member_id: "1",
        name: "lokkifriend",
        dob: "07.07.1999",
        relationship: "single",
    },
    member1: {
        profile_pic: "https://ik.imagekit.io/bfzb9z4tav/mesh/103160_man_512x512_q_3Ez9MguH.png?updatedAt=1616250842785",
        user_name: "lokki",
        email: "lokki.devprofile@gmail.com",
        contact: "+919578078950",
        gender: "male",
        dob: "08.07.1999",
        location: "erode",
        blood_group: "O+",
        willing_to_donate: "yes",
        office_name: "nutzindia",
        job: "dev",
        martial_status: "not married",
        role: "president",
        status: "active",

    },
    member2: {
        profile_pic: "https://ik.imagekit.io/bfzb9z4tav/mesh/103160_man_512x512_q_3Ez9MguH.png?updatedAt=1616250842785",
        user_name: "Amar",
        email: "johnamar20@gmail.com",
        contact: "+918526102999",
        gender: "male",
        dob: "01.07.1997",
        location: "erode",
        blood_group: "A+",
        willing_to_donate: "yes",
        office_name: "nutzindia",
        job: "dev",
        martial_status: "not married",
        role: "president",
        status: "active",

    },
    member3: {
        profile_pic: "https://ik.imagekit.io/bfzb9z4tav/mesh/103160_man_512x512_q_3Ez9MguH.png?updatedAt=1616250842785",
        user_name: "Arun",
        email: "arunsakthitech@gmail.com",
        contact: "+917667991441",
        gender: "male",
        dob: "28.02.1997",
        location: "erode",
        blood_group: "B+",
        willing_to_donate: "yes",
        office_name: "nutzindia",
        job: "dev",
        martial_status: "not married",
        role: "president",
        status: "active",

    },
    member4: {
        profile_pic: "https://ik.imagekit.io/bfzb9z4tav/mesh/103160_man_512x512_q_3Ez9MguH.png?updatedAt=1616250842785",
        user_name: "Siva Slapathy",
        email: "hvaocsiva@gmail.com",
        contact: "+912323566589",
        gender: "male",
        dob: "28.02.1997",
        location: "erode",
        blood_group: "B+",
        willing_to_donate: "yes",
        office_name: "nutzindia",
        job: "dev",
        martial_status: "not married",
        role: "president",
        status: "active",

    },
    role_of_honour1: {
        member_id: "1",
        role_of_honour_year: "2021",
    },
    role_of_honour2: {
        member_id: "2",
        role_of_honour_year: "2020",
    },
    role_of_honour3: {
        member_id: "3",
        role_of_honour_year: "2019",
    },
    role_of_honour4: {
        member_id: "4",
        role_of_honour_year: "2018",
    },
    board_member1: {
        member_id: "1",
    },
    board_member2: {
        member_id: "2",
    },
    board_member3: {
        member_id: "3",
    },
    sponser1: {
        sponser_name: "Nutz Technovation Pvt Ltd",
        sponser_image: "https://ik.imagekit.io/bfzb9z4tav/assets/Nutz_R_c7vy0Z41x_WOuMqHVIm.png?updatedAt=1627207700325",
        sponser_contact: "+919944448090",
        sponser_email: "nutztechnovation@gmail.com",
        sponser_description: "We will help to bring your wildest ideas into life..",
        sponser_location: "erode",
        sponser_website: "nutzindia.com",
        role: "1",
        status: "active",
    },
    sponser2: {
        sponser_name: "sponser",
        sponser_image: "https://upload.wikimedia.org/wikipedia/commons/0/0a/Logo_JCI.png",
        sponser_contact: "+911111111111",
        sponser_email: "sponser@gmail.com",
        sponser_description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce a odio tristique, gravida justo a, fermentum velit. Fusce cursus orci quis augue vulputate finibus. Suspendisse bibendum augue eget nisl venenatis eleifend.",
        sponser_location: "erode",
        sponser_website: "sponser.com",
        role: "0",
        status: "active",
    },
    userRoles: {
        role_name: "president",
    },
}


export const production = {
    database: {
        db_name: process.env.HS_DB_NAME,
        host: process.env.HS_DB_HOST,
        username: process.env.HS_DB_USERNAME,
        password: process.env.HS_DB_PASSWORD,
    },
    server: {
        port: process.env.HS_PORT || 3002,
    },
};