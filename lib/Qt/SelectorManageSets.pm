# Form implementation generated from reading ui file 'SelectorManageSets.ui'
#
# Created: Wed Oct 29 21:10:57 2003
#      by: The PerlQt User Interface Compiler (puic)
#
# WARNING! All changes made in this file will be lost!


use strict;
use utf8;


package SelectorManageSets;
use Qt;
use Qt::isa qw(Qt::Dialog);
use Qt::slots
    refreshPackageSetsListBox => [],
    createNewPackageSet => [],
    duplicateButton_clicked => [],
    renameButton_clicked => [],
    deleteButton_clicked => [],
    newCoreButton_clicked => [],
    newAllButton_clicked => [],
    doneButton_clicked => [],
    showEvent => [],
    packageSetsListBox_doubleClicked => ['QListBoxItem*'];
use Qt::attributes qw(
    packageSetsListBox
    duplicateButton
    renameButton
    deleteButton
    newCoreButton
    newAllButton
    doneButton
);

use lib "$ENV{OSCAR_HOME}/lib"; use OSCAR::Database;
use Qt::signals refreshPackageSets => [];
use SelectorUtils;

sub uic_load_pixmap_SelectorManageSets
{
    my $pix = Qt::Pixmap();
    my $m = Qt::MimeSourceFactory::defaultFactory()->data(shift);

    if($m)
    {
        Qt::ImageDrag::decode($m, $pix);
    }

    return $pix;
}


sub NEW
{
    shift->SUPER::NEW(@_[0..3]);

    if( name() eq "unnamed" )
    {
        setName("SelectorManageSets");
    }
    resize(315,227);
    setCaption(trUtf8("Manage OSCAR Package Sets"));

    my $SelectorManageSetsLayout = Qt::GridLayout(this, 1, 1, 11, 6, '$SelectorManageSetsLayout');

    my $Layout116 = Qt::HBoxLayout(undef, 0, 6, '$Layout116');

    packageSetsListBox = Qt::ListBox(this, "packageSetsListBox");
    packageSetsListBox->insertItem(trUtf8("New Item"));
    Qt::ToolTip::add(packageSetsListBox, trUtf8("List of all package sets"));
    $Layout116->addWidget(packageSetsListBox);

    my $Layout115 = Qt::VBoxLayout(undef, 0, 6, '$Layout115');

    duplicateButton = Qt::PushButton(this, "duplicateButton");
    duplicateButton->setText(trUtf8("D&uplicate"));
    Qt::ToolTip::add(duplicateButton, trUtf8("Copy the selected package set to a new package set"));
    $Layout115->addWidget(duplicateButton);

    renameButton = Qt::PushButton(this, "renameButton");
    renameButton->setText(trUtf8("&Rename"));
    Qt::ToolTip::add(renameButton, trUtf8("Rename the selected package set to a new name"));
    $Layout115->addWidget(renameButton);

    deleteButton = Qt::PushButton(this, "deleteButton");
    deleteButton->setText(trUtf8("&Delete"));
    Qt::ToolTip::add(deleteButton, trUtf8("Delete the selected package set"));
    $Layout115->addWidget(deleteButton);

    newCoreButton = Qt::PushButton(this, "newCoreButton");
    newCoreButton->setText(trUtf8("New &Core"));
    Qt::ToolTip::add(newCoreButton, trUtf8("Create a new package set with just \"core\" packages"));
    $Layout115->addWidget(newCoreButton);

    newAllButton = Qt::PushButton(this, "newAllButton");
    newAllButton->setText(trUtf8("New &All"));
    Qt::ToolTip::add(newAllButton, trUtf8("Create a new package set with all packages"));
    $Layout115->addWidget(newAllButton);
    my $spacer = Qt::SpacerItem(0, 20, &Qt::SizePolicy::Minimum, &Qt::SizePolicy::Expanding);
    $Layout115->addItem($spacer);

    doneButton = Qt::PushButton(this, "doneButton");
    doneButton->setText(trUtf8("D&one"));
    doneButton->setOn(0);
    Qt::ToolTip::add(doneButton, trUtf8("Close this window"));
    $Layout115->addWidget(doneButton);
    $Layout116->addLayout($Layout115);

    $SelectorManageSetsLayout->addLayout($Layout116, 0, 0);

    Qt::Object::connect(duplicateButton, SIGNAL "clicked()", this, SLOT "duplicateButton_clicked()");
    Qt::Object::connect(renameButton, SIGNAL "clicked()", this, SLOT "renameButton_clicked()");
    Qt::Object::connect(deleteButton, SIGNAL "clicked()", this, SLOT "deleteButton_clicked()");
    Qt::Object::connect(doneButton, SIGNAL "clicked()", this, SLOT "doneButton_clicked()");
    Qt::Object::connect(packageSetsListBox, SIGNAL "doubleClicked(QListBoxItem*)", this, SLOT "packageSetsListBox_doubleClicked(QListBoxItem*)");
    Qt::Object::connect(newCoreButton, SIGNAL "clicked()", this, SLOT "newCoreButton_clicked()");
    Qt::Object::connect(newAllButton, SIGNAL "clicked()", this, SLOT "newAllButton_clicked()");
}


sub refreshPackageSetsListBox
{

#########################################################################
#  Subroutine: refreshPackageSetsListBox                                #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This subroutine should be called anytime you need to refresh the     #
#  contents of the packageSetsListBox.  For example, when you rename    #
#  a package set, delete a package set, or duplicate a package set, the #
#  list needs to be updated.  This subroutine also emits a signal to    #
#  let the main window know that the package set list has changed to    #
#  update its packageSetComboBox.                                       #
#########################################################################

  SelectorUtils::populatePackageSetList(packageSetsListBox);
  emit refreshPackageSets();

}

sub createNewPackageSet
{

#########################################################################
#  Subroutine: createNewPackageSet                                      #
#  Parameter : Name of the new package set                              #
#  Returns   : The (possibly modified) name of the new package set      #
#  This subroutine is called by "duplicate", "new core", and            #
#  "new all" to create a (unique) new package set.  The "suggested"     #
#  name is passed in.  We say "suggested" because we first check to     #
#  see if that name already exists in the list of package sets.  If so, #
#  we append "_copy" as many times as necessary to get a unique name.   #
#  Then we add this new package set name to the oda database.  Note     #
#  that we don't actually refresh the contents of the listbox.  You     #
#  MUST do that later on.                                               #
#########################################################################

  my $newSetName = shift;

  my $nameclash;
  do # Check for a unique name
    {
      $nameclash = 0;
      for (my $count = 0; $count < packageSetsListBox->count(); $count++)
        {
          if (lc(packageSetsListBox->text($count)) eq lc($newSetName))
            { # Found the name in the list.  Append another "copy".
              $nameclash = 1;
              $newSetName .= "_copy";
            }
        }
    } while ($nameclash);
  
  # Add the new name to the database and to the ListBox
  my $success = OSCAR::Database::database_execute_command(
    "create_package_set $newSetName");
  Carp::carp("Could not do oda command 'create_package_set $newSetName'") if 
    (!$success);

  return $newSetName;

}

sub duplicateButton_clicked
{

#########################################################################
#  Subroutine: duplicateButton_clicked                                  #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the "Duplicate" button is clicked.  It finds     #
#  the item currently selected in the ListBox and creates a new package #
#  set named that same name with "_copy" appended.                      #
#########################################################################

  # Check to see if we actually have something selected in the listbox
  if (packageSetsListBox->currentItem() >= 0)
    { 
      my $lastSet = packageSetsListBox->currentText();
      my $currSet = createNewPackageSet($lastSet);

      # Copy all of the packages listed in the old package set
      # over to the newly created package set.
      my @packagesInSet;
      my $success = OSCAR::Database::database_execute_command(
        "packages_in_package_set $lastSet",\@packagesInSet);
      Carp::carp("Could not do oda command 'packages_in_package_set " .
        $lastSet . "'") if (!$success);
      foreach my $pack (@packagesInSet)
        {
          $success = OSCAR::Database::database_execute_command(
            "add_package_to_package_set $pack $currSet"); 
          Carp::carp("Could not do oda command 'add_package_to_package_set " .
            "$pack $currSet'") if (!$success);
        }
      
      # Finally, refresh the listbox with the new entry
      refreshPackageSetsListBox();
    }

}

sub renameButton_clicked
{

#########################################################################
#  Subroutine: renameButton_clicked                                     #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the "Rename" button is clicked.  It finds the    #
#  item currently selected in the ListBox and prompts the user for a    #
#  new name.  It then renames that item in the ListBox and in the oda   #
#  database.                                                            #
#########################################################################

  # Check to see if we actually have something selected in the listbox
  if (packageSetsListBox->currentItem() >= 0)
    { 
      my $response;
      my $foundit;
      my $count;
      my $success;
      my $error = 0;
      my $ok = 0;
      my $outputstr = "Enter a new name for '" . 
                      packageSetsListBox->currentText() . "':";
      do # Keep prompting the user for a new name until success
        {
          $ok = 0;  # Was the OK button pressed, or the Cancel button?
          $error = 0;
          $response = Qt::InputDialog::getText("Rename Package Set",
                        $outputstr, Qt::LineEdit::Normal(), "", $ok, this);
          $response = SelectorUtils::compactSpaces($response);
          $response =~ s/ /_/g; # Change spaces to underscores

          if (($ok) && (length($response) > 0))
            {
              # Check to see if the new string already exists
              $foundit = 0;
              for ($count=0; 
                   ($count < packageSetsListBox->count()) && (!$foundit); 
                   $count++)
                {
                  $foundit = 1 if 
                    (lc(packageSetsListBox->text($count)) eq lc($response));
                }
              
              if ($foundit)
                {
                  $error = 1;
                  $outputstr = "Package Set '$response' already exists. \n" .
                               "Enter a new name for '" . 
                               packageSetsListBox->currentText() . "':";
                }
              else
                {
                  my $selected = packageSetsListBox->currentText();
                  $success = OSCAR::Database::database_execute_command(
                    "rename_package_set $selected $response");
                  if ($success)
                    {
                      refreshPackageSetsListBox();
                    }
                  else
                    {
                      Carp::carp("Could not do oda command " . 
                        "'rename_package_set $selected $response'");
                    }
                }
            }
          elsif ($ok) # BUT, the input string turned out to be empty
            { 
              $error = 1;
              $outputstr = "Please try again. \nEnter a new name for '".
                           packageSetsListBox->currentText(). "':";
            }
        } while ($error);
    }

}

sub deleteButton_clicked
{

#########################################################################
#  Subroutine: deleteButton_clicked                                     #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the "Delete" button is clicked.  It finds the    #
#  package set currently selected in the ListBox and removes it from    #
#  both the ListBox and the oda database.                               #
#########################################################################

  # Make sure that we have at least 2 items in the list 
  # and that at least one of them is selected.
  if ((packageSetsListBox->currentItem() >= 0) &&
      (packageSetsListBox->count() > 1))
    { 
      my $selected = packageSetsListBox->currentText();
      my $success = OSCAR::Database::database_execute_command(
        "delete_package_set $selected");
      if ($success)
        {
          refreshPackageSetsListBox();
        }
      else 
        {
          Carp::carp("Could not do oda command 'delete_package_set $selected'");
        }
    }

}

sub newCoreButton_clicked
{

#########################################################################
#  Subroutine: newCoreButton_clicked                                    #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the "New Core" button is clicked.  It creates    #
#  a new package set named "Core" (with _copy appended as needed)       #
#  and adds only core packages to that set.                             #
#########################################################################

  my $currSet = createNewPackageSet("Core");
  # Add all "core" packages to this set
  my $allPackages = SelectorUtils::getAllPackages();
  foreach my $pack (keys %{ $allPackages })
    {
      if ($allPackages->{$pack}{class} eq "core")
        {
          my $success = OSCAR::Database::database_execute_command(
            "add_package_to_package_set $pack $currSet"); 
          Carp::carp("Could not do oda command 'add_package_to_package_set " .
            "$pack $currSet'") if (!$success);
        }
    }

  refreshPackageSetsListBox();

}

sub newAllButton_clicked
{

#########################################################################
#  Subroutine: newAllButton_clicked                                     #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the "New All" button is clicked.  It creates     #
#  a new package set named "All" (with _copy appended as needed)        #
#  and adds ALL packages to that set.                                   #
#########################################################################

  my $currSet = createNewPackageSet("All");
  # Add all packages to this set
  my $allPackages = SelectorUtils::getAllPackages();
  foreach my $pack (keys %{ $allPackages })
    {
      my $success = OSCAR::Database::database_execute_command(
        "add_package_to_package_set $pack $currSet"); 
      Carp::carp("Could not do oda command 'add_package_to_package_set " .
        "$pack $currSet'") if (!$success);
    }

  refreshPackageSetsListBox();

}

sub doneButton_clicked
{

#########################################################################
#  Subroutine: doneButton_clicked                                       #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the "Done" button is clicked.  It 'hides'        #
#  the Manage Package Sets window so we don't have to create it again.  #
#########################################################################

  hide();

}

sub showEvent
{

#########################################################################
#  Subroutine: showEvent                                                #
#  Parameters: None                                                     #
#  Returns   : Nothing                                                  #
#  This is called when the Manage Package Sets window is shown.  It     #
#  rebuilds the items in the List box each time.                        #
#########################################################################

  refreshPackageSetsListBox();

}

sub packageSetsListBox_doubleClicked
{

#########################################################################
#  Subroutine: packageSetsListBox_doubleClicked                         #
#  Parameters: Pointer to the QListBoxItem that was clicked             #
#  Returns   : Nothing                                                  #
#  This gets called when the user double-clicks on one of the package   #
#  set's names in the ListBox.  It simply calls the "renameButton"      #
#  code to rename that item.                                            #
#########################################################################

  renameButton_clicked();

}

1;
