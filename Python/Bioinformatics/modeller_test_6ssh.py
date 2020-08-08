# -*- coding: utf-8 -*-
"""
Created on Fri Aug  7 13:52:26 2020

@author: bjwil
"""

from modeller import *
from modeller.automodel import *



log.verbose()
env = environ()
env.io.atom_files_directory = ['.', 'C:\\Users\\bjwil\\Downloads']
aln = alignment(env)
mdl1 = model(env, file='6ssh', model_segment=('FIRST:A', 'LAST:A'))
#mdl2 = model(env, file='1srq', model_segment=('FIRST:A', 'LAST:A'))
#mdl3 = model(env, file='3brw', model_segment=('FIRST:A', 'LAST:A'))
aln.append_model(mdl1, align_codes='6ssh')
#aln.append_model(mdl2, align_codes='1srq')
#aln.append_model(mdl3, align_codes='3brw')
aln.append(file = 'C:\\Users\\bjwil\\Downloads\\TSC2_1503-1729.pir', align_codes=('TSC2_HUMAN'))
#aln.align(gap_penalties_1d=(-600, -400))
aln.salign(gap_penalties_1d=(-600, -400))
aln.write('TSC2_6ssh_salign.ali', alignment_format='PIR')



log.verbose() # may not need again??
env = environ() # may not need again??
env.io.atom_files_directory = ['.', 'C:\\Users\\bjwil\\Downloads'] # may not need again??


class automodel_newname(automodel):
    '''
    Eugene Radchenko <genie@qsar.chem.msu.ru> and I wrote to Modeller
    so that we can add a ROOT_NAME parameter to add for the models
    because we might want to run more than 1 structural alignment on same
    sequence but with another template.  Therefore should be able to 
    enter ROOT_NAME for files else it defaults to target sequence.  This class
    Overrides that functionality.
    
    Dear Ben,
 
    I asked a similar question some time ago and unfortunately get_model_filename is not enough.
    The problem is that the code has “file = self.sequence + '.xxx'” and “root_name=self.sequence”  and “root_name=sequence” sprinkled all over the place (and also loopmodel has a separate get_loop_model_filename).
 
    I second the request to provide a nice get_root_name or get_job_name hook (defaulting to self.sequence) it would be very convenient because often one has to play with various model parameters for the same sequence and alignment.

    Benn Webb said he would add it to the next release:
    From	Subject	Received	Size	Categories	
    Modeller Caretaker	Re: [modeller_usage] Change ROOT_NAME for automodel.make()	Fri 7:58 PM	77 KB		
    
    Indeed, as I said it would require changing the Python code. But since that is very easy I just did so - will be in the next release.

    Ben Webb, Modeller Caretaker
    --
    '''

    def __init__(self, env, alnfile, knowns, sequence, root_name=None):
        super().__init__(env, alnfile, knowns, sequence)
        if root_name:
            self.root_name = root_name
        else:
            self.root_name = sequence
        self.reset_defaults()
        
         
    def reset_defaults(self):
        """
        Set most default variables
        Since automodel __init__ calls set_defaults() we need to
        "Override" by recalling this if we want to use super().__init__() above
        """
        self.inifile = self.root_name + '.ini'
        self.csrfile = self.root_name + '.rsr'
        self.schfile = self.root_name + '.sch'
        self.generate_method = generate.transfer_xyz
        self.rand_method = randomize.xyz
        self.md_level = refine.very_fast
    
    
    def get_model_filename(self, root_name, id1, id2, file_ext):
        """Returns the model PDB name - usually of the form foo.B000X000Y.pdb"""
        return modfile.default(file_id='.B', file_ext=file_ext,
                               root_name=self.root_name, id1=id1, id2=id2)
    
    
    def new_trace_file(self, num):
        """Open a new optimization trace file"""
        if self.trace_output > 0:
            filename = modfile.default(file_ext='', file_id='.D',
                                       root_name=self.root_name, id1=0, id2=num)
            return open(filename, 'w')
        else:
            return None
    
    
    def model_analysis(self, atmsel, filename, out, num):
        """Energy evaluation and assessment, and write out the model"""
        if self.accelrys:
            # Write the final model (Accelrys wants it before calculating the
            # profiles, so that the Biso column contains the original
            # template-derived averages)
            self.write(file=filename, model_format=self.output_model_format)
            for (id, norm) in (('.E', False), ('.NE', True)):
                atmsel.energy(output='LONG ENERGY_PROFILE',
                              normalize_profile=norm,
                              file=modfile.default(file_id=id, file_ext='',
                                                   root_name=self.sequence,
                                                   id1=9999, id2=num))
            # The new request from Lisa/Azat to print out only
            # stereochemical restraint violations (6/24/03):
            # select only stereochemical restraints (maybe add dihedral
            # angles?):
            scal = physical.values(default=0, bond=1, angle=1, dihedral=1,
                                   improper=1, soft_sphere=1,
                                   disulfide_distance=1, disulfide_angle=1,
                                   disulfide_dihedral=1)
            for (id, norm) in (('.ES', False), ('.NES', True)):
                e = atmsel.energy(output='ENERGY_PROFILE',
                                  normalize_profile=norm, schedule_scale=scal,
                                  file=modfile.default(file_id=id,
                                                       file_ext='',
                                                       root_name=self.sequence,
                                                       id1=9999, id2=num))
            (out['molpdf'], out['pdfterms']) = e
            self.user_after_single_model()
            # Do model assessment if requested
            self.assess(atmsel, self.assess_methods, out)
        else:
            # Do model assessment if requested
            assess_keys = self.assess(atmsel, self.assess_methods, out)

            e = atmsel.energy(output='LONG VIOLATIONS_PROFILE',
                              file=modfile.default(file_id='.V', file_ext='',
                                                   root_name=self.root_name,
                                                   id1=9999, id2=num))

            (out['molpdf'], out['pdfterms']) = e
            self.user_after_single_model()

            # Write the final model; Biso contains the violations profile
            self.write_final_model(filename, assess_keys, out)
            
    
    
a = automodel_newname(env = env,
                      alnfile = 'TSC2_6ssh_test.ali',
                      knowns = ('6ssh'),
                      sequence = 'TSC2_HUMAN',
                      root_name = 'TSC2_6ssh_test')

a.starting_model= 1                 # index of the first model
a.ending_model  = 2                 # index of the last model
                                    # (determines how many models to calculate)
a.make()                            # do the actual comparative modeling



#modfile.default(root_name='TSC2_6ssh', file_id='.B', id1=9999, id2=1, file_ext='.pdb')
#a.get_model_filename(sequence = 'TSC2_6ssh', id1=9999, id2=1, file_ext='.pdb')
