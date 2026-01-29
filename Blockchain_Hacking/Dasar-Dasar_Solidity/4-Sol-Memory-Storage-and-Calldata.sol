// SPDX-License-Identifier: MIT
pragma solidity >=0.8.18 <0.9.0; // stating the version

contract SimpleStorage {
   uint256 myFavoriteNumber; // inisiasi myFavoriteNumber secara default bervalue 0

   // uint256[] listMyFavoriteNumber; -> dynamic array ; kalau static, di dalam kurung persegi ada valuenya.
   // struct
   struct otherPerson{
       uint256 hisFavoriteNumber;
       string name;
   }

    // Add data / value manually on struct
    // otherPerson public Akmal = otherPerson({hisFavoriteNumber: 77, name: "Akmal"});
    // otherPerson public Tiko = otherPerson({hisFavoriteNumber: 88, name: "Tiko"});

    otherPerson[] public listOfOtherPerson; // [] -> empty list

   function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
   }

    // view, pure : view -> return variable ; pure -> return value
   function retrieve() public view returns(uint256){
        return myFavoriteNumber;
   }

    // fungsi untuk menambah data orang ke dalam struct otherPerson
    // calldata, memory, storage
    // calldata & memory -> temporary
    // storage -> permanent
    // perbedaan calldata dan memory -> variabel dari memory dapat diubah, sedangkan calldata tidak
    // contoh kasusnya adalah coba ubah value _name (yang menggunakan memory) di dalam fungsi menjadi "akmal" maka tidak eror, sedangkan jika pakai calldata tidak
   function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfOtherPerson.push(otherPerson(_favoriteNumber, _name));
   }
}            
