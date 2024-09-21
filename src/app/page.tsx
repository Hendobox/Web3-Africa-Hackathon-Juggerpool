"use client";

import { Button, Container, Flex, Heading } from "@chakra-ui/react";
import { ConnectKitButton } from "connectkit";

export default function Home() {
  return (
    <Container p={4} w="screen">
      <Flex w="100%" alignItems="center" justifyContent="flex-end">
        <ConnectKitButton.Custom>
          {({ isConnected, show, truncatedAddress, ensName }) => {
            return (
              <Button colorScheme="teal" onClick={show}>
                {isConnected ? (ensName ?? truncatedAddress) : "Connect Wallet"}
              </Button>
            )
          }}
        </ConnectKitButton.Custom>
      </Flex>
      <Heading variant="h1">
        JuggerPool
      </Heading>
    </Container>
  );
}
