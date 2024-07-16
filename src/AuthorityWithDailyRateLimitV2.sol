// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/access/Ownable2Step.sol";

struct DecryptionRequest {
    bytes32 c1Hash;
    uint256 expireTime;
}

contract CircularBuffer {
    uint8 public constant CAPACITY = 10;

    DecryptionRequest[CAPACITY] public decReqs;

    // Represents the index in the array of the oldest element
    uint8 public start;

    // Represents the next position to write to
    uint8 public end;

    // Represents the number of elements in decReqs
    uint8 public size;

    function append(DecryptionRequest calldata decReq) public {
        decReqs[end] = decReq;
        end = (end + 1) % CAPACITY;

        if (size < CAPACITY) {
            size += 1;
        } else {
            // start was just verwritten
            start = (start + 1) % CAPACITY;
        }
    }

    function getStart() public view returns (DecryptionRequest memory) {
        return decReqs[start];
    }

    function getEnd() public view returns (DecryptionRequest memory) {
        return decReqs[end];
    }

    function getDecReqs() public view returns (DecryptionRequest[CAPACITY] memory) {
        return decReqs;
    }
}

/// @notice Owner can request 10 decryptions per 24 hours. Each decryption request
/// expires within 24 hours. If a decryptor has an unexpired decryption request
/// for a given c1Hash when canDecrypt is called, then canDecrypt returns true.
contract AuthorityWithDailyRateLimitV2 is Ownable2Step {
    
    uint256 public constant EXPIRE_OFFSET = 1 days;

    // We use circular buffers for our rolling rate limit implementation.
    mapping(address => CircularBuffer) public decryptorToDecReqBuff;

    event DecryptionRequestCreated(address decryptor, bytes32 c1Hash);

    event DecryptorInitialized(address decryptor);
    
    error RateLimit(string msg);

    constructor() Ownable(msg.sender) {}

    function canDecrypt(address decryptor, bytes32 c1Hash) external view returns (bool) {
        CircularBuffer decReqBuff = decryptorToDecReqBuff[decryptor];
        if (address(decReqBuff) == address(0)) {
            return false;
        }

        // Iterate through decryptor's decryption requests to see if they have a valid request
        DecryptionRequest[10] memory decReqs = decReqBuff.getDecReqs();
        for (uint8 i = 0; i < decReqs.length; i++) {
            if (decReqs[i].c1Hash == c1Hash && decReqs[i].expireTime > block.timestamp) {
                return true;
            }
        }

        return false;
    }

    // TODO: In the future, we could probably use OpenZeppelin's role based access control.
    // We can create a decryptor role. We can modify requestDecryption to allow only
    // decryptors. We can add functions that allow the owner to add and remove decryptors.
    // We might want to add a limit on the total number of allowed decryptors. Otherwise,
    // there is a risk that we add so many decryptors that the rate limit is no longer
    // effective. I.e., if we rate limit per decryptor, and if we have many decryptors,
    // then possibly a significant amount of user data can be decrypted at once.

    function requestDecryption(bytes32 c1Hash) external onlyOwner() {
        CircularBuffer decReqBuff = decryptorToDecReqBuff[msg.sender];
        
        // If decReqBuff is null, instantiate it, and insert the new request
        if (address(decReqBuff) == address(0)) {
            decReqBuff = new CircularBuffer();
            decryptorToDecReqBuff[msg.sender] = decReqBuff;
            emit DecryptorInitialized(msg.sender);
            insertNewDecReq(msg.sender, c1Hash, decReqBuff);
        }
        // If decReqBuff is not null and isn't full, simply add the new request
        else if (decReqBuff.size() < decReqBuff.CAPACITY()) {
            insertNewDecReq(msg.sender, c1Hash, decReqBuff);
        }
        // If decReqBuff is not null and is full, make sure the oldest request is expired
        else {
            // In circular buffer, oldest request is at end; newest is at start.
            DecryptionRequest memory oldestDecReq = decReqBuff.getEnd();
            if (oldestDecReq.expireTime > block.timestamp) {
                revert RateLimit("Oldest request is not expired. A decryptor can only make 10 requests per 24 hours.");
            }

            // If oldests request is expired, overwrite the oldest request with the new request
            insertNewDecReq(msg.sender, c1Hash, decReqBuff);
        }
    }

    function insertNewDecReq(address decryptor, bytes32 c1Hash, CircularBuffer decReqBuff) private {
        decReqBuff.append(DecryptionRequest(c1Hash, newExpireTime()));
        emit DecryptionRequestCreated(decryptor, c1Hash);
    }

    function newExpireTime() public view returns (uint256) {
        return block.timestamp + EXPIRE_OFFSET;
    }
}
