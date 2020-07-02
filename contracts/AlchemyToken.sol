// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract AlcToken {
    string public name = "AlcToken";
    string public symbol = "ALC";
    uint8 public decimals = 2;
    uint256 public totalSupply = 10000000000000;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    modifier onlyValidAddress(address _account) {
        require(_account == address(0), "Invalid address supplied.");
        _;
    }

    modifier onlyOwner(address _owner) {
        require(msg.sender == _owner, "Sender not authorized.");
        _;
    }

    modifier hasSufficientFunds(address _owner, uint256 _value) {
        require(
            _balances[_owner] >= _value,
            "Sender does not have sufficient funds"
        );
        _;
    }

    function balanceOf(address _owner)
        public
        view
        onlyValidAddress(msg.sender)
        returns (uint256 balance)
    {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value)
        public
        onlyValidAddress(msg.sender)
        onlyOwner(msg.sender)
        hasSufficientFunds(msg.sender, _value)
        returns (bool success)
    {
        _balances[msg.sender] = _balances[msg.sender] - _value;
        _balances[_to] = _balances[_to] + _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        onlyValidAddress(_from)
        onlyValidAddress(_to)
        hasSufficientFunds(_from, _value)
        returns (bool success)
    {
        _balances[_from] = _balances[_from] - _value;
        _balances[_to] = _balances[_to] + _value;
        _allowed[_from][msg.sender] = _allowed[_from][msg.sender] - _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        onlyOwner(msg.sender)
        onlyValidAddress(_spender)
        hasSufficientFunds(_spender, _value)
        returns (bool success)
    {
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        public
        view
        onlyValidAddress(_owner)
        onlyValidAddress(_spender)
        returns (uint256 remaining)
    {
        return _allowed[_owner][_spender];
    }
}
