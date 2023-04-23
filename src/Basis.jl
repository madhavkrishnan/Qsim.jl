# Generate basis elements.

const z0 = SparseVector(2, [1], [1])
const z1 = SparseVector(2, [2], [1])


"""
function basis(qbits::BitVector)

Function to return a z-basis vector given a bitvector of qubit z-values . 
"""
function basis(qbits::BitVector)
		
	args = (q ? z1 : z0 for q in qbits)

	if(length(args) == 1)
		return collect(args)[1]
	end

	return kron(args...)
	
end
	
function zero_state(qbits::Integer)
		
	return SparseVector(2^qbits, [1], [1])
	
end

