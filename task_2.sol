// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract rentalCotract {
   struct Property {
        address owner; // Mülk sahibi
        string propertyType; // Mülk türü (ev veya dükkan)
        address tenant; // Kiracı

    }

    struct Lease {
        uint256 startDate; // Kira başlangıç tarihi
        uint256 endDate; // Kira bitiş tarihi
        bool isRented; // Kiralanmış mı
        bool isTerminated; // Kiralama sonlandırıldı mı
    }

    mapping (address => Property) public properties;
    mapping (address => Lease) public leases;

    event PropertyAdded(address indexed propertyAddress, string propertyType, address owner);
    event LeaseStarted(address indexed propertyAddress, uint256 startDate, uint256 endDate);
    event LeaseTerminated(address indexed propertyAddress);


    // mülk oluşturma
    function addProperty(address _propertyAddress, string memory _propertyType) public {
        require(properties[_propertyAddress].owner == address(0), "Property already exists");
        properties[_propertyAddress] = Property(msg.sender, _propertyType, address(0));
        emit PropertyAdded(_propertyAddress, _propertyType, msg.sender);

    }
    // Kiralama
    function startLease(address _propertyAddress, address _tenant, uint256 _startDate, uint256 _endDate) public {
        Property storage property = properties[_propertyAddress];
        require(property.owner == msg.sender, "Only property owner can start a lease");
        require(!leases[_propertyAddress].isRented, "Property is already rented");
        leases[_propertyAddress] = Lease(_startDate, _endDate, true, false);
        property.tenant = _tenant;
        emit LeaseStarted(_propertyAddress, _startDate, _endDate);
    }

    // Kira sözleşmesi sonlandırma 
    function terminateLease(address _propertyAddress) public {
        Property storage property = properties[_propertyAddress];
        Lease storage lease = leases[_propertyAddress];
        require(property.owner == msg.sender, "Only property owner can terminate the lease");
        require(lease.isRented, "Property is not rented");
        lease.isRented = false;
        lease.isTerminated = true;
        emit LeaseTerminated(_propertyAddress);
    }
}