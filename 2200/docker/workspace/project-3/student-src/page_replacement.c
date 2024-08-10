#include "types.h"
#include "pagesim.h"
#include "mmu.h"
#include "swapops.h"
#include "stats.h"
#include "util.h"

pfn_t select_victim_frame(void);

pfn_t last_evicted = 0;

/**
 * --------------------------------- PROBLEM 7 --------------------------------------
 * Checkout PDF section 7 for this problem
 * 
 * Make a free frame for the system to use. You call the select_victim_frame() method
 * to identify an "available" frame in the system (already given). You will need to 
 * check to see if this frame is already mapped in, and if it is, you need to evict it.
 * 
 * @return victim_pfn: a phycial frame number to a free frame be used by other functions.
 * 
 * HINTS:
 *      - When evicting pages, remember what you checked for to trigger page faults 
 *      in mem_access
 *      - If the page table entry has been written to before, you will need to use
 *      swap_write() to save the contents to the swap queue.
 * ----------------------------------------------------------------------------------
 */
pfn_t free_frame(void) {
    pfn_t victim_pfn;
    victim_pfn = select_victim_frame();

    fte_t *ft_entry = &frame_table[victim_pfn];
    // TODO: evict any mapped pages. usally occur when the no empty frame is left we need to evict other frame base on the page replacement policy
    if (ft_entry->mapped) {
        pcb_t *victim_process = ft_entry->process;
        vpn_t victim_vpn = ft_entry->vpn;
        pte_t *victim_pte = ((pte_t *)(mem+ (victim_process->saved_ptbr * PAGE_SIZE))) + victim_vpn;
        if (victim_pte->dirty) {
            swap_write(victim_pte,(uint8_t*) (mem + (victim_pfn * PAGE_SIZE)));
            stats.writebacks++;
        }
        victim_pte->valid = 0;
        victim_pte->dirty = 0;
    }
        ft_entry->mapped = 0;

    return victim_pfn;
}



/**
 * --------------------------------- PROBLEM 9 --------------------------------------
 * Checkout PDF section 7, 9, and 11 for this problem
 * 
 * Finds a free physical frame. If none are available, uses either a
 * randomized, FCFS, or clocksweep algorithm to find a used frame for
 * eviction.
 * 
 * @return The physical frame number of a victim frame.
 * 
 * HINTS: 
 *      - Use the global variables MEM_SIZE and PAGE_SIZE to calculate
 *      the number of entries in the frame table.
 *      - Use the global last_evicted to keep track of the pointer into the frame table
 * ----------------------------------------------------------------------------------
 */
pfn_t select_victim_frame() {
    /* See if there are any free frames first */
    size_t num_entries = MEM_SIZE / PAGE_SIZE;
    for (size_t i = 0; i < num_entries; i++) {
        if (!frame_table[i].protected && !frame_table[i].mapped) {
            return i;
        }
    }

    // RANDOM implemented for you.
    if (replacement == RANDOM) {
        /* Play Russian Roulette to decide which frame to evict */
        pfn_t unprotected_found = NUM_FRAMES;
        for (pfn_t i = 0; i < num_entries; i++) {
            if (!frame_table[i].protected) {
                unprotected_found = i;
                if (prng_rand() % 2) {
                    return i;
                }
            }
        }
        /* If no victim found yet take the last unprotected frame
           seen */
        if (unprotected_found < NUM_FRAMES) {
            return unprotected_found;
        }


    } else if (replacement == FIFO) {
        // TODO: Implement the FIFO algorithm here
        //Loop around the frame table until you find the first unprotected frame and return it.
        for(int i = 0; (size_t)i <= num_entries; i++){
            size_t victim_pfn =((size_t)(last_evicted + i) % num_entries);
            if (frame_table[victim_pfn].protected == 0) {
                last_evicted = victim_pfn % num_entries + 1;
                return victim_pfn;
            }
        }
    } else if (replacement == CLOCKSWEEP) {
        // TODO: Implement the clocksweep page replacement algorithm here 
        //the algorithm guarantees at least one full sweep across all page frames.
        // num_entries * 2;   edge case where the queue is all reference
        //choose the first page that does not have its reference bit set to 1. If all of the page table entries have their reference bit set then this will become FIFO.
        for(int i = 0; (size_t)i <= num_entries * 2; i++){
            size_t victim_pfn =((size_t)(last_evicted + i) % num_entries);
            if (frame_table[victim_pfn].protected == 0) {
                vpn_t vpn = frame_table[victim_pfn].vpn;
                pte_t *pte = (pte_t *)(mem+((frame_table[victim_pfn].process->saved_ptbr) * PAGE_SIZE)) + vpn; 
                if(pte->referenced == 0){
                    last_evicted = (victim_pfn) % num_entries + 1;
                    return victim_pfn;
                }else{
                    pte->referenced = 0;
                }
            }
        }    
    }

    /* If every frame is protected, give up. This should never happen
       on the traces we provide you. */
    panic("System ran out of memory\n");
    exit(1);
}
