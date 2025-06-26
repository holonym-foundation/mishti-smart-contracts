// SPDX-License-Identifier: BUSL-1.1

// Run with `forge script script/SetVaultOptIn.s.sol:SetSupportedStakingContracts --broadcast --verify --rpc-url https://eth.llamarpc.com --etherscan-api-key I1Z396K67WH81P7J7FSAK6AF6WI8WPTQPD --evm-version cancun --hd-paths "m/44'/60'/2'/0/0" --ledger`
pragma solidity >=0.8.20;

import {Script, StdChains} from "forge-std/src/Script.sol";
import "forge-std/src/console.sol";

contract SetSupportedStakingContracts is Script {
    address public multisigAddress = address(0); // For testing purposes
    address public targetContract = 0x42F15F9E4dF4994317453477e80e24797CC1A929; // Target contract address

    function run() public {
        vm.createSelectFork(
            "https://eth-mainnet.g.alchemy.com/v2/w7VeFPv25C_k2L0D4FA1zUXMzhV9_toI"
        );
        vm.startBroadcast();
        // Define staking contract details
        IAvsGovernance.StakingContractInfo[]
            memory stakingContracts = new IAvsGovernance.StakingContractInfo[](
                42
            );

        stakingContracts[0] = IAvsGovernance.StakingContractInfo(
            0x0dB67D60d98cF8d27C8720110c7793929f091cc2,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Ryabina wBTC
        stakingContracts[1] = IAvsGovernance.StakingContractInfo(
            0x0FDf3B986d62bE6aE1D5228e5DA90ff6f00c15F6,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // NodeInfra USDB Bima Mellow infra
        stakingContracts[2] = IAvsGovernance.StakingContractInfo(
            0x0Fe4F44beE93503346A3Ac9EE5A26b130a5796d6,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // swETH strategy
        stakingContracts[3] = IAvsGovernance.StakingContractInfo(
            0x108784D6B93A010f62b652b2356697dAEF3D7341,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Hashkey Cloud Restaked ETH
        stakingContracts[4] = IAvsGovernance.StakingContractInfo(
            0x13760F50a9d7377e4F20CB8CF9e4c26586c658ff,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // ankrETH strategy
        stakingContracts[5] = IAvsGovernance.StakingContractInfo(
            0x1BeE69b7dFFfA4E2d53C2a2Df135C388AD25dCD2,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // rETH strategy
        stakingContracts[6] = IAvsGovernance.StakingContractInfo(
            0x298aFB19A105D59E74658C4C334Ff360BadE6dd2,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // mETH strategy
        stakingContracts[7] = IAvsGovernance.StakingContractInfo(
            0x2Bcfa0283C92b7845ECE12cEaDc521414BeF1067,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // ETHFI vault
        stakingContracts[8] = IAvsGovernance.StakingContractInfo(
            0x35E44d92E8F738A272Bddbae53d1Dc9490e75Fe7,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // P2P wBTC vault
        stakingContracts[9] = IAvsGovernance.StakingContractInfo(
            0x369d807C75a37279D26ADEb2dEED1A8491283bE4,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        );
        stakingContracts[10] = IAvsGovernance.StakingContractInfo(
            0x3bA6930baC1630873F5fd206e293cA543Fcea7A2,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet sUSDe vault
        stakingContracts[11] = IAvsGovernance.StakingContractInfo(
            0x446970400e1787814CA050A4b45AE9d21B3f7EA7,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // MEV capital
        stakingContracts[12] = IAvsGovernance.StakingContractInfo(
            0x450a90fdEa8B87a6448Ca1C87c88Ff65676aC45b,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // wstETH vault
        stakingContracts[13] = IAvsGovernance.StakingContractInfo(
            0x4b873da454d038b10A87Eb196bdbcD43E28B3012,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        );
        stakingContracts[14] = IAvsGovernance.StakingContractInfo(
            0x4e0554959A631B3D3938ffC158e0a7b2124aF9c5,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // MEV Capital vault
        stakingContracts[15] = IAvsGovernance.StakingContractInfo(
            0x54945180dB7943c0ed0FEE7EdaB2Bd24620256bc,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // cbETH strategy
        stakingContracts[16] = IAvsGovernance.StakingContractInfo(
            0x57ba429517c3473B6d34CA9aCd56c0e735b94c02,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // osETH strategy
        stakingContracts[17] = IAvsGovernance.StakingContractInfo(
            0x65B560d887c010c4993C8F8B36E595C171d69D63,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet vault
        stakingContracts[18] = IAvsGovernance.StakingContractInfo(
            0x7b276aAD6D2ebfD7e270C5a2697ac79182D9550E,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // wstETH vault
        stakingContracts[19] = IAvsGovernance.StakingContractInfo(
            0x7CA911E83dabf90C90dD3De5411a10F1A6112184,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // wBETH strategy
        stakingContracts[20] = IAvsGovernance.StakingContractInfo(
            0x81bb35c4152B605574BAbD320f8EABE2871CE8C6,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet vault
        stakingContracts[21] = IAvsGovernance.StakingContractInfo(
            0x82c304aa105fbbE2aA368A83D7F8945d41f6cA54,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // cp0x conservative vault
        stakingContracts[22] = IAvsGovernance.StakingContractInfo(
            0x8327b8BD2561d28F914931aD57370d62C7968e40,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Nansen x Gauntlet Lido v3 stVault
        stakingContracts[23] = IAvsGovernance.StakingContractInfo(
            0x8CA7A5d6f3acd3A7A8bC468a8CD0FB14B6BD28b6,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // sfrxETH strategy
        stakingContracts[24] = IAvsGovernance.StakingContractInfo(
            0x9205c82D529A79B941A9dF2f621a160891F57a0d,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // MEV Capital vault
        stakingContracts[25] = IAvsGovernance.StakingContractInfo(
            0x93b96D7cDe40DC340CA55001F46B3B8E41bC89B4,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Ryabina wstETH
        stakingContracts[26] = IAvsGovernance.StakingContractInfo(
            0x93c4b944D05dfe6df7645A86cd2206016c51564D,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // stETH strategy
        stakingContracts[27] = IAvsGovernance.StakingContractInfo(
            0x9d7eD45EE2E8FC5482fa2428f15C971e6369011d,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // ETHx strategy
        stakingContracts[28] = IAvsGovernance.StakingContractInfo(
            0xa4C637e0F704745D182e4D38cAb7E7485321d059,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // 0ETH strategy
        stakingContracts[29] = IAvsGovernance.StakingContractInfo(
            0xa88e91cEF50b792f9449e2D4C699b6B3CcE1D19F,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Renzo vault
        stakingContracts[30] = IAvsGovernance.StakingContractInfo(
            0xaCB55C530Acdb2849e6d4f36992Cd8c9D50ED8F7,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // EIGEN strategy
        stakingContracts[31] = IAvsGovernance.StakingContractInfo(
            0xAe60d8180437b5C34bB956822ac2710972584473,
            IAvsGovernance.SharedSecurityProvider.EigenLayer
        ); // lsETH strategy
        stakingContracts[32] = IAvsGovernance.StakingContractInfo(
            0xaF07131C497E06361dc2F75de63dc1d3e113f7cb,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet vault
        stakingContracts[33] = IAvsGovernance.StakingContractInfo(
            0xbA60b6969fAA9b927A0acc750Ea8EEAdcEd644B7,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet vault with Mantle
        stakingContracts[34] = IAvsGovernance.StakingContractInfo(
            0xB8Fd82169a574eB97251bF43e443310D33FF056C,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet vault
        stakingContracts[35] = IAvsGovernance.StakingContractInfo(
            0xbA91473072EBD125C3cB8D251fd02bf21FDea8Df,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // InfraSingularity Restaked ETH
        stakingContracts[36] = IAvsGovernance.StakingContractInfo(
            0xc10A7f0AC6E3944F4860eE97a937C51572e3a1Da,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // Gauntlet vault
        stakingContracts[37] = IAvsGovernance.StakingContractInfo(
            0xD25f31806de8d608D05DfeAEB1140C1D365864B3,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // MEV Capital vault
        stakingContracts[38] = IAvsGovernance.StakingContractInfo(
            0xd4E20ECA1f996Dab35883dC0AD5E3428AF888D45,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // LBTC vault
        stakingContracts[39] = IAvsGovernance.StakingContractInfo(
            0xdC47953c816531a8CA9E1D461AB53687d48EEA26,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // MEV Capital vault
        stakingContracts[40] = IAvsGovernance.StakingContractInfo(
            0xEa0F2EA61998346aD39dddeF7513ae90915AFb3c,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        );
        stakingContracts[41] = IAvsGovernance.StakingContractInfo(
            0xF60E6E6d8648FdBC2834EF7bC6f5E49aB55bec31,
            IAvsGovernance.SharedSecurityProvider.Symbiotic
        ); // MEV Capital vault

        // Prank the multisig address and call the function
        // vm.prank(multisigAddress);
        IAvsGovernance(targetContract).setSupportedStakingContracts(
            stakingContracts
        );
    }
}

interface IAvsGovernance {
    enum SharedSecurityProvider {
        EigenLayer,
        Symbiotic
    }

    struct StakingContractInfo {
        address stakingContract;
        SharedSecurityProvider sharedSecurityProvider;
    }

    function setSupportedStakingContracts(
        StakingContractInfo[] memory _stakingContractsDetails
    ) external;
}
