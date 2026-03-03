# Data Chunks and Flows Terminology

In the context of collective operations, a **data chunk** refers to a partition of a rank’s buffer.

Assume a collective defined by the following parameters:

- **Data size (S)**: total buffer size per rank  
- **Rank count (R)**: total number of participating ranks  
- **QPs per Rank Pair (Q)**: number of Queue Pairs between each pair of ranks  

Each rank's buffer of size `S` is divided into `R` equal parts, resulting in data chunks of size `S / R`.

Depending on the algorithm, each rank may send or operate on one or more data chunks during a given phase of the 
collective. For example:

- In a **unidirectional ring all-reduce**, a rank typically transfers one data chunk per step.
- In a **halving-doubling all-reduce**, a rank might send half of its buffer in one phase, and a single data chunk in 
another.


Each data chunk transfer is mapped onto `Q` **network flows**, corresponding to the number of QPs between the 
communicating ranks.

- With the current implementation, the data is evenly distributed across the flows.
  - **Example**: A 5 MB chunk with `Q = 5` results in 5 flows, each handling 1 MB of data.

On the wire, each flow is transmitted using **RoCEv2 packets**, which may include:
- `ONLY` or
- `FIRST`
- One or more `MIDDLE`
- `LAST`

---

## Summary of Terminology

| Term | Description |
|------|-------------|
| **Data Chunk** | A partition of a rank's buffer of size `S / R`. |
| **Data Chunk Transfer** | Transfer of one or more data chunks from one rank to another, as defined by the collective algorithm. These form the building blocks of the collective operation. |
| **Flow** | A data chunk transfer over a single QP. Each flow is a sequence of RDMA messages between two ranks on a specific QP. |
| **RDMA Message** | One or more RoCEv2 packets. If the RDMA message size exceeds the InfiniBand MTU and Adaptive Routing is not enabled (planned for future support), the message is split into multiple packets. |
