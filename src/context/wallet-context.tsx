"use client";

import { WalletConfig } from "@/config/wallet";
import { ChakraProvider } from "@chakra-ui/react";
import { CacheProvider } from '@chakra-ui/next-js';
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConnectKitProvider } from "connectkit";
import { WagmiProvider } from "wagmi";

const queryClient = new QueryClient();

type Props = {
    children: React.ReactNode
}

export const Web3Provider = ({ children }: Props) => {
    return (
        <CacheProvider>
            <ChakraProvider>
                <WagmiProvider config={WalletConfig}>
                    <QueryClientProvider client={queryClient}>
                        <ConnectKitProvider>
                            {children}
                        </ConnectKitProvider>
                    </QueryClientProvider>
                </WagmiProvider>
            </ChakraProvider>
        </CacheProvider>
    )
}