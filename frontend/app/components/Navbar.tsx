'use client'

import Link from "next/link";
import {useState, useEffect} from "react";
import {FaPlus} from "react-icons/fa";
import {useNextKeycloakAuth} from "@krashnakant/next-keycloak";
import {KeycloakLoginOptions} from "keycloak-js";

type MyNote = {
    id: string;
    title: string;
    content: string;
    createdAt: number;
    updatedAt: number;
};

const Navbar = () => {
    const [notes, setNotes] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const {
        authenticated,
        login,
        register,
        userInfo,
        loading,
        token,
        logout,
        hasRealmRole,
    } = useNextKeycloakAuth();

    const handleLogin = () => {
        const option: KeycloakLoginOptions = {
            redirectUri: window.location.origin,
        };
        console.log("logging in");
        login(option);
    };
    useEffect(() => {
        const fetchNotes = async () => {
            console.log("fetching notes");
            const res = await fetch(`https://nirvana.ooguy.com/api/v1/notes`, {
                headers: {
                    Accept: "application/json",
                    Authorization: `Bearer ${token}`,
                },
            });
            const data: MyNote[] = await res.json();

            setNotes(data);
            setIsLoading(false);
        };
        console.log(authenticated ? "authenticated" : "not authenticated");
        if (authenticated) {
            fetchNotes().catch((err) => {
                alert("Error fetching notes, or no notes exist. Please try again later. Check console for error.")
                console.log(err)
            });
        }
    }, [authenticated, token]);


    return (
        <header className="flex flex-row justify-between py-4">
            <div className="px-4">
                <Link href={"/"} className="font-bold text-lg">
                    Nirvana notes
                </Link>
            </div>
            <div>
                <ul className="flex flex-row">
                    <li className="mx-2">
                        <Link href={"/notes"}>Notes</Link>
                    </li>
                    {authenticated ? (
                        <>
                            <li className="mx-2">
                                <Link href={"/"}>Profile</Link>
                            </li>
                            <li className="mx-2">
                                <button
                                    onClick={() => logout({redirectUri: window.location.origin})}
                                >
                                    Logout
                                </button>
                            </li>
                        </>
                    ) : (
                        <>
                            <li className="mx-2">
                                <button onClick={handleLogin}>Login</button>
                            </li>
                            <li className="mx-2">
                                <button onClick={() => register()}>Register</button>
                            </li>
                        </>
                    )}
                </ul>
            </div>
            <div className="px-3">
                <Link
                    href={"/new"}
                    className="flex cursor-pointer bg-green-600 py-2 px-2 rounded-md text-white"
                    onClick={() => console.log("clicked")}
                >
                    <span>Add note</span> <FaPlus className="mt-1 ml-2"/>
                </Link>
            </div>
        </header>
    );
};

export default Navbar;
