# RFX-TOKEN-
Smart contract deployment details for RFX Token
Token Contract
- Name: RecycleFlux (RFX)
- Contract Address: 0xf24F1b77822E131129cae24f71BD905aa799fEEa
- Decimals: 18
- Total Supply: 6000 RFX (with anti-dump rules built in)

  ABI
See [ABI.json](./ABI.json)

Network Info
- Network: Ethereum Sepolia Testnet
- Chain ID: 11155111
- Block Explorer: [https://sepolia.etherscan.io](https://sepolia.etherscan.io)
- RPC URL (Public): https://rpc.sepolia.org

Usage
Developers can:
1. Import ABI.json into frontend/backend.
2. Use the *contract address* + *RPC URL* above to interact with the token.
3. Call standard ERC-20 functions (transfer, approve, balanceOf, etc.) + custom anti-dump rules (built into _transfer).
