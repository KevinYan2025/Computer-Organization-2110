#include "mmu.h"
#include "pagesim.h"
#include "swapops.h"
#include "stats.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"

/**
 * --------------------------------- PROBLEM 6 --------------------------------------
 * Checkout PDF section 7 for this problem
 * 
 * Page fault handler.
 * 
 * When the CPU encounters an invalid address mapping in a page table, it invokes the 
 * OS via this handler. Your job is to put a mapping in place so that the translation 
 * can succeed.
 * 
 * @param addr virtual address in the page that needs to be mapped into main memory.
 * 
 * HINTS:
 *      - You will need to use the global variable current_process when
 *      altering the frame table entry.
 *      - Use swap_exists() and swap_read() to update the data in the 
 *      frame as it is mapped in.
 * ----------------------------------------------------------------------------------
 */
void page_fault(vaddr_t addr) {
   // TODO: Get a new frame, then correctly update the page table and frame table
   // CPU encounters an invalid VPN to PFN mapping in the page table,
   //allocates a new frame for the page by either finding an empty frame or evicting a page from a frame that is in use.
//    1. Get the page table entry for the faulting virtual address.

   vpn_t vpn = vaddr_vpn(addr);

   pfn_t victim_pfn = free_frame();// 2. Using free_frame() get the PFN of a new frame.
   pte_t *pte = ((pte_t *)(mem + (PTBR * PAGE_SIZE))) + vpn;
   // 3. Check to see if there is an existing swap entry for the faulting page table entry. 
   if(swap_exists(pte)){
      // 4. If a swap entry exists, then use swap_read() to read in the saved frame into the new frame, otherwise clear the new frame.
      swap_read(pte,mem + (victim_pfn * PAGE_SIZE));//bring previous store content fron disk in to physical memory
   } else {
       memset(mem + (victim_pfn * PAGE_SIZE), 0, PAGE_SIZE); //clear frame if no sawp
   }
   // 5. Update the mapping from VPN to the new PFN in the current process’ page table.
   pte->pfn = victim_pfn;
   pte->valid = 1;
   pte->dirty = 0;
   pte->referenced = 1; //for page replacement policy

   //update frame table entry
   fte_t *ft_entry = &frame_table[victim_pfn];
   ft_entry->mapped = 1;
   ft_entry->process = current_process;
   ft_entry->vpn = vpn;
   ft_entry->protected = 0;
   stats.page_faults++;
}

#pragma GCC diagnostic pop
