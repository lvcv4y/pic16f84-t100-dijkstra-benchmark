/* Place the trojan function at a fixed virtual address
 * while preserving the default RISC-V Linux linker script.
 * Partially written by ChatGPT.
 */

SECTIONS
{
  /* Sets trojan-section at 0x400ff8, so that the function
   * first instruction lands at 0x400100.
   */
  .trojan-section 0x400ff8 :
  {
    KEEP(*(.trojan-section))
  }

  /*
   * Sets target at 0x200000 to make address target selection easier.
   */
  .target 0x200000 :
  {
    KEEP(*(.target))
  }
} INSERT AFTER .text;
