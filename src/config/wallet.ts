import { arbitrumSepolia } from "wagmi/chains";
import { createConfig, http } from "wagmi";
import { getDefaultConfig } from "connectkit";

export const ALCHEMY_ID = process.env.NEXT_PUBLIC_ALCHEMY_ID || "";
export const WALLET_CONNECT_ID = process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || "";
// https://arb-sepolia.g.alchemy.com/v2/dJfMgavRlSU3QbAc1eEWlaWcii49cPac

export const WalletConfig = createConfig(
    getDefaultConfig({
        chains: [arbitrumSepolia],
        transports: {
            // [arbitrum.id]: http(
            //     `https://arb-mainnet.g.alchemy.com/v2/#{ALCHEMY_ID}`
            // ),
            [arbitrumSepolia.id]: http(
                `https://arb-sepolia.g.alchemy.com/v2/#{ALCHEMY_ID}`
            )
        },
        walletConnectProjectId: WALLET_CONNECT_ID,
        appName: "JuggerVault",
        appUrl: "http://localhost:3000"
    })    
)