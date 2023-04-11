'use client'
// Not needed in a TSX file, remove this line
import Link from "next/link";
import {useState, useEffect} from "react";
import {FaPlus} from "react-icons/fa";
import {useNextKeycloakAuth} from "@krashnakant/next-keycloak";
import {KeycloakLoginOptions} from "keycloak-js";

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
            const res = await fetch("/api/notes");
            const data = await res.json();
            setNotes(data);
            setIsLoading(false);
        };

        fetchNotes();
    }, []);

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
                        <li className="mx-2">
                            <button onClick={handleLogin}>Login</button>
                            <button onClick={() => register()}>Register</button>
                        </li>
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
