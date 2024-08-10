#pragma once

#include "mmu.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

/**
 * --------------------------------- PROBLEM 1 --------------------------------------
 * Checkout PDF Section 3 For this Problem
 *
 * Split the virtual address into its virtual page number and offset.
 * 
 * HINT: 
 *      -Examine the global defines in pagesim.h, which will be necessary in 
 *      implementing these functions.
 * ----------------------------------------------------------------------------------
 */
static inline vpn_t vaddr_vpn(vaddr_t addr) {
    // TODO: return the VPN from virtual address addr.
    //right shift to remove the least significant bit, and use vpn to index into page table(PT) to find the page table entry(PTE)
    return (addr >> OFFSET_LEN);
}

static inline uint16_t vaddr_offset(vaddr_t addr) {
    // TODO: return the offset into the frame from virtual address addr.
    //((1 << OFFSET_LEN) - 1)  set all the lowest 14 bit to 1 and perfom bitmask using &
    return addr & ((1 << OFFSET_LEN) - 1);
    //use offset to index into page frame to find page entry
}

#pragma GCC diagnostic pop
