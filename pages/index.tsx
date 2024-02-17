import type { NextPage } from "next";
import { SignInButton, ethos } from "ethos-connect";
import { Disconnect, Mint, WalletActions } from "../components";
import Script from 'next/script';
import Image from 'next/image';
import { useCallback, useEffect, useState } from "react";

const Home: NextPage = () => {
  const { status, wallet } = ethos.useWallet();

  return (
    <div className="flex justify-between items-start">
      <div className="p-12 flex-1">Status: {status}</div>

      <div className="max-w-7xl mx-auto text-center py-12 px-4 sm:px-6 lg:py-16 lg:px-8 flex-6">
        {!wallet ? (
          <SignInButton className="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">
            Connect
          </SignInButton>
        ) : (
          <div id="main-container" className="flex flex-col gap-6">
            <div className="flex flex-col gap-2">
              <h2 id="headline" className="text-3xl font-extrabold tracking-tight sm:text-4xl">
                Solve the Puzzle to Mint
              </h2>
            </div>
            <div className="flex flex-col gap-4">
            <div id="canvas-container">
                <div id="sound-canvas">
                </div>
                <div id="overlay-image">
                  <Image 
                    id="validated-canvas-overlay" 
                    src="/brisebois2.jpg"
                    width={444}
                    height={444}
                    alt="skull puzzle"
                  /> 
                </div>
              </div>
  
              <Mint/>
              or
              <Disconnect />
            </div>
            <Script src="../headbreaker.js"/>
          </div>
        )}
      </div>

      <div className="p-12 flex-1 flex justify-end">
        <ethos.components.AddressWidget 
          // excludeButtons={[
          //   ethos.enums.AddressWidgetButtons.WalletExplorer
          // ]} 
        />
      </div>
    </div>
  );
};

export default Home;
