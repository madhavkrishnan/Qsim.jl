# Single qubit gates

const id = sparse([1 0; 0 1])

const H = sqrt(1/2) * sparse([1 1; 1 -1])

const X = sparse([0 1 ; 1 0])

const Z = sparse([1 0 ; 0 -1])

const Y = 1im * X * Z

const S = sparse([1 0 ; 0  1im])

const T = sparse([1 0; 0 exp(1im * pi / 4)])

# Projection operators

const pz0 = sparse([1  0; 0 0])
const pz1 = sparse([0  0; 0 1])

"""
  qbit_op(gate, qbit::Integer, qmax::Integer)

Returns a qmax qubit operator with the provided gate acting on a single qubit. 

"""
function qbit_op(gate, qbit::Integer, qmax::Integer)

	# Check that gate is a single qubit operator
	size(gate) == (2,2) || error("Input gate must be a single qubit operator.")
	1 <= qbit <= qmax || error("Qubit out of bounds.")

	if(qmax==1)
		return gate
	end

	# Edge cases
	if(qbit == 1 || qbit == qmax )
		id =  sparse(1I, 2^(qmax -1), 2^(qmax-1))

		op = qbit == 1 ? kron(gate, id) : kron(id, gate)
		return op
	end

	# Middle case
	id1 =  sparse(1I, 2^(qbit - 1), 2^(qbit - 1))
	id2 =  sparse(1I, 2^(qmax - qbit), 2^(qmax - qbit))

	return kron(id1, gate, id2)
end

"""
	function qubit_op(gate, qbits::Vector{Integer}, qmax)

Returns a qmax qubit operator with the provided gate acting on multiple qubits. 

"""
function qbit_op(gate, qbits::Vector{Integer}, qmax)

end

# Controlled Operations
"""
	function ctrl_op(gate, cqbit::Integer, tqbit::Integer, qmax::Integer)

Returns a controlled version of gate with control and target bits defined by cqbit and tqbit in space with dimension 2^qmax.

"""
function ctrl_op(gate, cqbit::Integer, tqbit::Integer, qmax::Integer)

# Checks that qubits are valid arguments
cqbit != tqbit || error("Control and target qubits cannot be the same.")
1 <= cqbit <= qmax || error("Control out of bounds.")
1 <= tqbit <= qmax || error("Target out of bounds.")

# Check that gate is a single qubit operator
size(gate) == (2,2) || error("Input gate must be a single qubit operator.")

# Build Controlled gate (|0><0|xI + |1><1| x g) 
gate_off = qbit_op(pz0, cqbit, qmax)
gate_on  = qbit_op(pz1, cqbit, qmax)
gate_action = qbit_op(gate, tqbit, qmax)


return gate_off + gate_on * gate_action

end



