# CompArch Midterm

This midterm is to be completed entirely on your own with no assistance from or collaboration with
other humans.
You are free to use course slides, your notes, textbooks, online references, ModelSim, etc. You must
document (in writing, including specific titles/URLs) any resources you use other than the course slides.
You may consult with me or the NINJAs, in person or via private questions on Piazza. Please start early -
we will stop offering assistance other than simple clarification questions starting 48 hours before the
deadline.
Due date: before midnight on Sunday, November 15
Submit by pushing your Specification Document, Block Diagram, and Schematics (with sizes) to GitHub
as PDF or MarkDown.

#Problem Summary
Your job for this Midterm is to reproduce part of a real product currently available for sale as faithfully
and as cheaply as possible. You will be cloning the LED controller in a bike light.
This bike light has four modes: Off, On, Blinking, and Dim (On at approximately 50% brightness). It cycles
through the modes by pressing a single button.
Specification Document
Write a brief but informative specification document that clearly captures the design intent of the digital
electronics portion of the product. This section should include:
• Inputs and Outputs. These are a single button and a single LED, but you need to state that
clearly in your document.
• All operational modes of the system
o Consider showing blink patterns graphically
• Measurements of relevant dimensions in appropriate units with actual numbers
o E.g. 10Hz, rather than “quickly”
This section should NOT include:
• Any information about the mechanical aspect of the product
• Any implementation details. Explain what it does, not how it does it.
This should be roughly one page, including figures / charts / FSM diagrams. Another engineer should be
able to take your spec document and recreate the device with no additional information.
Hint: I like http://wavedrom.com/editor.html and http://madebyevan.com/fsm/ for simple figures

#Block Diagram
This is where you begin to answer “How”. Create a high-level block diagram view of a digital circuit that
implements the system laid out in your specification document. Be sure to read the entire assignment
before doing this aspect, as there are hints embedded in the scaffolding for the other deliverables. This
document is written top-down for context, but can be done in the order that makes you happiest.

#Schematic
Each of the components in your Block Diagram needs to be expanded hierarchically. At the bottom of
the hierarchy are basic components: NAND, NOR, AND, OR, XOR, XNOR, NOT, Buffer, D Flip Flop,
Multiplexer, Decoder. If you require additional components, they are to be built hierarchically.
For each new component you use, provide the following:
1) Specification. This is a 1-3 sentence description of what the component does.
2) Inputs
3) Outputs
4) Schematic
5) Size of the component in terms of the number of Gate Inputs it uses.

#Cost Estimation Model
Estimate the cost of your design in terms of silicon area consumed. For this Midterm, we will assume
that cost linearly scales with the number of gate inputs for basic inverting gates. Non-inverting gates
cost 1 extra for the implicit inverter. Express your area costs in Gate Input Equivalents (GIE).